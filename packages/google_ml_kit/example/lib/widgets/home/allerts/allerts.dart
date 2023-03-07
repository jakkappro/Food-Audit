import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/allerts_model.dart';

class Allerts extends StatefulWidget {
  const Allerts({Key? key, this.allerts}) : super(key: key);
  final List<Allert>? allerts;

  @override
  _AllertsState createState() => _AllertsState();
}

class _AllertsState extends State<Allerts> {
  @override
  Widget build(BuildContext context) {
    if (widget.allerts != null) {
      return Column(
        children: [
          const SizedBox(height: 25),
          const Center(
            child: Text(
              'Najnovšie upozornenia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Stack(
            children: [
              SizedBox(
                height: 230,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allerts!.length,
                  itemBuilder: (context, index) {
                    final allert = widget.allerts![index].title
                        .split(' - ')
                        .skip(1)
                        .join(' ')
                        .replaceAll('\n', ' ');
                    return SizedBox(
                      height: 110,
                      child: Card(
                        child: ListTile(
                          title: Text(
                            allert.length > 55
                                ? '${allert.substring(0, 52)}...'
                                : allert,
                          ),
                          subtitle: TextButton(
                            child: const Text('Čítaj viac'),
                            onPressed: () async {
                              await launchUrlString(widget.allerts![index].url);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   width: MediaQuery.of(context).size.width,
              //   height: 50,
              //   child: ClipRRect(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(
              //         sigmaX: 1.5,
              //         sigmaY: 1.5,
              //       ), //this determines the blur in the x and y directions best to keep to relitivly low numbers
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [
              //               Colors.black.withOpacity(0),
              //               Colors.black.withOpacity(
              //                 0.4,
              //               ), //This controls the darkness of the bar
              //             ],
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //             // stops: [0, 1], if you want to adjust the gradiet this is where you would do it
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      );
    }
    return Column(
      children: const [
        Center(
          child: Text(
            'Načítavam upozornenia ...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: CircularProgressIndicator(),
        ),
        SizedBox(height: 25),
        Center(
          child: CircularProgressIndicator(),
        ),
        SizedBox(height: 25),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
