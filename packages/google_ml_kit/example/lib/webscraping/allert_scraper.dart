import 'package:http/http.dart' as http;
import 'package:webfeed_plus/domain/rss_feed.dart';

class AllertScraper {
  Future<List<Map<String, String>>> getAllerts() async {
    final response = await http.get(Uri.parse(
        'https://webgate.ec.europa.eu/rasff-window/backend/public/consumer/rss/all/'));
    if (response.statusCode == 200) {
      final channel = RssFeed.parse(response.body);

      final fitness = <Map<String, String>>[];
      for (var i = 0; i < 5; i++) {
        fitness.add({
          'title': channel.items![i].title!,
          'url': channel.items![i].link!,
        });
      }
      return fitness;
    } else {
      throw Exception('Failed to load allerts');
    }
  }
}
