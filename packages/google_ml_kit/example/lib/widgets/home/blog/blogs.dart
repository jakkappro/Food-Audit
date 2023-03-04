// TODO: make this class automatically generate tabs based on the number of blogs, and pass all the blogs to the tab

import 'package:flutter/material.dart';

import '../../../helpers/challenges_helpers.dart';
import '../../../models/webscraping_model.dart';
import '../decorated_container.dart';
import 'blog_content.dart';
import 'blog_tab.dart';

class Blogs extends StatefulWidget {
  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 445,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  'Blog',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  'Aktuálne trendy v stravovaní',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: 370,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                  primary: false,
                  backgroundColor: Colors.transparent,
                  bottom: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    isScrollable: false,
                    padding: EdgeInsets.only(top: 0, bottom: 0),
                    tabs: [
                      BlogTab(name: 'Výživa'),
                      BlogTab(name: 'Cvičenie'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    // Nutritional
                    DecoratedContainer(
                      body: BlogContent(
                        model: WebScrapingModel.receipesInstance,
                        onTap: () async => await updateBlogChallenge(),
                      ),
                      width: width,
                      height: 350,
                      shouldCenter: true,
                    ),
                    // Exercise
                    DecoratedContainer(
                      body: BlogContent(
                        model: WebScrapingModel.fitnessInstance,
                        onTap: () async => await updateBlogChallenge(),
                      ),
                      width: width,
                      height: 350,
                      shouldCenter: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
