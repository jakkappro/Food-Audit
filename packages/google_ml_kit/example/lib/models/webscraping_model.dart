import '../webscraping/fitnes_scraper.dart';
import '../webscraping/myths_scraper.dart';

class WebScrapingModel {
  static WebScrapingModel? _recepiesInstance;
  static WebScrapingModel? _fitnessInstance;

  static WebScrapingModel get receipesInstance {
    _recepiesInstance ??= WebScrapingModel._internal();
    return _recepiesInstance!;
  }

  static WebScrapingModel get fitnessInstance {
    _fitnessInstance ??= WebScrapingModel._internal();
    return _fitnessInstance!;
  }

  WebScrapingModel._internal();

  Future<void> loadFromWeb(bool receipes) async {
    title = [];
    url = [];
    image = [];

    if (receipes) {
      final data = await RecipeScraper().getRecipes();
      for (final receipe in data) {
        title.add(receipe['title']!);
        url.add(receipe['url']!);
        image.add(receipe['image']!);
      }
    } else {
      final data = await FitnessScraper().getFitness();
      for (final fitnessBlog in data) {
        title.add(fitnessBlog['title']!);
        url.add(fitnessBlog['url']!);
        image.add(fitnessBlog['image']!);
      }
    }
  }

  late List<String> title;
  late List<String> url;
  late List<String> image;
}
