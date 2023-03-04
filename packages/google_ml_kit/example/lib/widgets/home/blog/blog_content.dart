import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/webscraping_model.dart';

class BlogContent extends StatelessWidget {
  const BlogContent({Key? key, required this.onTap, required this.model})
      : super(key: key);

  final VoidCallback onTap;
  final WebScrapingModel model;

  @override
  Widget build(BuildContext context) {
    final maxCharacters = (MediaQuery.of(context).size.width - 40) ~/ 15;
    return Padding(
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: model.image.isNotEmpty
                          ? model.image[index]
                          : 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
                      placeholder: (context, url) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.errorContainer,
                        );
                      },
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      maxHeightDiskCache: 200,
                      maxWidthDiskCache: 184,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title.isNotEmpty
                            ? model.title[index].length > maxCharacters
                                ? '${model.title[index].substring(0, maxCharacters - 3)}...'
                                : model.title[index]
                            : 'Zlyhanie pripojenia',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          onTap();
                          if (model.url.isNotEmpty) {
                            await launchUrlString(model.url[index]);
                          }
                        },
                        child: Text(
                          'Čítaj ďalej',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
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
    );
  }
}
