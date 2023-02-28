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
      width: width * 0.89,
      height: 430,
      child: Column(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  'Blog',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 22),
                child: Text(
                  'Aktuálne trendy v stravovaní',
                  style: TextStyle(
                    color: Color.fromRGBO(218, 218, 218, 1),
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
          Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 360,
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
                    indicatorColor: Colors.black,
                    indicatorWeight: 3,
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
                        onTap: updateBlogChallenge,
                      ),
                      width: width,
                      height: 350,
                      shouldCenter: false,
                    ),
                    // Exercise
                    DecoratedContainer(
                      body: BlogContent(
                        model: WebScrapingModel.fitnessInstance,
                        onTap: updateBlogChallenge,
                      ),
                      width: width,
                      height: 350,
                      shouldCenter: false,
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
