import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class FitnessScraper {
  Future<List<Map<String, String>>> getFitness() async {
    final response = await http.get(Uri.parse(
        'https://www.bornfitness.com/blog/'));
    if (response.statusCode == 200) {
      final document = parse(response.body);
      final articleTitles = document.getElementsByClassName('entry-title');
      final imagesList = document.getElementsByClassName('featured-image');
      final fitness = <Map<String, String>>[];
      for (var i = 0; i < 3; i++) {
        fitness.add({
          'title': articleTitles[i].firstChild!.text!,
          'image': imagesList[i].nodes[1].attributes['src'] ?? 'fuk',
          'url': imagesList[i].attributes['href'] ?? 'fuk2',
        });
      }
      return fitness;
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}