import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../models/settings_model.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    SettingsModel.instance.firstTime = false;
    SettingsModel.instance.saveToFirebase();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/$assetName',
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
      boxDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(40, 48, 70, 1),
              Color.fromRGBO(60, 78, 104, 1)
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.transparent,
          allowImplicitScrolling: true,
          autoScrollDuration: 0,
          globalHeader: Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: _buildImage('icons/splashLog.png', 100),
              ),
            ),
          ),
          globalFooter: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: const Text(
                'Let\'s go right away!',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _onIntroEnd(context),
            ),
          ),
          pages: [
            PageViewModel(
              title: 'Stravuj sa zdravo',
              body: 'Vylepši svoj jedálniček a zbav sa nebezpečných "Éčok"',
              image: _buildImage('onboarding/healthy_eating.jpg'),
              decoration: pageDecoration.copyWith(
                fullScreen: false,
                safeArea: 0,
                imageAlignment: Alignment.center,
                imagePadding: EdgeInsets.only(top: 155),
                bodyAlignment: Alignment.bottomCenter,
                descriptionPadding: EdgeInsets.only(bottom: 140),
              ),
            ),
            PageViewModel(
              title: 'Si alergický?',
              body:
                  'Nastav si na aké látky si alergický a už nikdy nebudeš musieť hľadať či môžeš zjesť niečo čo si si vybral',
              image: _buildImage('onboarding/settings.jpg'),
              decoration: pageDecoration.copyWith(
                  safeArea: 100,
                  bodyFlex: 1,
                  imageFlex: 2,
                  fullScreen: false,
                  imagePadding: EdgeInsets.only(top: 120)),
            ),
            PageViewModel(
              title: 'Novinky vo fitness a zdraví',
              body: 'Každý deň máme nachystané nové články o zdraví a fitness',
              image: _buildImage('onboarding/news.jpg'),
              decoration: pageDecoration.copyWith(
                safeArea: 20,
                imagePadding: EdgeInsets.only(top: 120),
                fullScreen: false,
              ),
            ),
            PageViewModel(
              title: 'Zbieraj body a získať odmeny',
              body:
                  'Zbieraj body za používanie aplikácie, predbiehaj sa s ostatnými a získaj odmeny',
              image: _buildImage('onboarding/challenges.jpg'),
              decoration: pageDecoration.copyWith(
                contentMargin: const EdgeInsets.symmetric(horizontal: 16),
                fullScreen: false,
                bodyFlex: 2,
                imageFlex: 4,
                safeArea: 10,
              ),
            ),
          ],
          onDone: () => _onIntroEnd(context),
          onSkip: () =>
              _onIntroEnd(context), // You can override onSkip callback
          //showSkipButton: true,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: true,
          //rtl: true, // Display as right-to-left
          back: const Icon(Icons.arrow_back, color: Colors.white),
          skip: const Text('Skip',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          next: const Icon(Icons.arrow_forward, color: Colors.white),
          done: const Text('Done',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: const EdgeInsets.all(16),
          controlsPadding: kIsWeb
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          dotsContainerDecorator: const ShapeDecoration(
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
        ),
      ),
    );
  }
}
