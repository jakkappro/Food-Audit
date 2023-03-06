import '../webscraping/allert_scraper.dart';
import '../webscraping/fitnes_scraper.dart';
import '../webscraping/myths_scraper.dart';

class AllertsModel {
  static AllertsModel? _allertsInstance;

  static AllertsModel get allertsInstance {
    _allertsInstance ??= AllertsModel._internal();
    return _allertsInstance!;
  }

  AllertsModel._internal();

  Future<void> loadFromWeb() async {
    title = [];

    final data = await AllertScraper().getAllerts();
    for (final myth in data) {
      title.add(Allert(myth['title']!, myth['url']!));
    }
  }

  List<Allert> title = [];
}

class Allert {
  final String title;
  final String url;

  Allert(this.title, this.url);
}
