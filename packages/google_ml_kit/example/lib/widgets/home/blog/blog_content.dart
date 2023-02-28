import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/webscraping_model.dart';

class BlogContent extends StatelessWidget {
  const BlogContent(
      {Key? key, required this.onTap, required this.model})
      : super(key: key);

  final VoidCallback onTap;
  final WebScrapingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(model.image[index]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title[index].length > 20
                              ? '${model.title[index].substring(0, 20)}...'
                              : model.title[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            onTap();
                            await launchUrlString(model.url[index]);
                          },
                          child: const Text(
                            'Čítaj ďalej',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
