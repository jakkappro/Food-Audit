import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class RecipeScraper {
  Future<List<Map<String, String>>> getRecipes() async {
    final response = await http.get(Uri.parse(
        'https://minimalistbaker.com/recipe-index/?fwp_sort=date_desc'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final recipeList = document.getElementsByClassName('post-summary__title');
      final imageList = document.getElementsByClassName('post-summary__image');
      final recipes = <Map<String, String>>[];
      final il = imageList[0].nodes[0];
      for (var i = 0; i < 3; i++) {
        recipes.add({
          'title': recipeList[i].firstChild!.text!,
          'image': imageList[i].nodes[0].attributes['src'] ?? '',
          'url': recipeList[i].firstChild!.attributes['href']!,
        });
      }
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}