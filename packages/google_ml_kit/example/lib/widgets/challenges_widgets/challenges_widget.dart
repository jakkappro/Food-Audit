import 'package:flutter/material.dart';

import '../../models/settings_model.dart';
import 'challenges_card.dart';

class ChallengesUI extends StatefulWidget {
  const ChallengesUI(
      {Key? key,
      required this.loginFinished,
      required this.blogFinished,
      required this.scanFinished})
      : super(key: key);
  final bool loginFinished;
  final bool blogFinished;
  final bool scanFinished;

  @override
  State<ChallengesUI> createState() => _ChallengesUIState();
}

class _ChallengesUIState extends State<ChallengesUI> {
  List<bool> panelOpen = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    // get challenges data from firebase
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.85,
      height: height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceTint,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'New User Challenges',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    panelOpen[index] = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Nastav si alergeny',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                !SettingsModel.instance.challenges['allergens']!
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                            decoration:
                                SettingsModel.instance.challenges['allergens']!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Chod do nastavení a nastav si alergeny',
                        style: TextStyle(
                          fontSize: 16,
                          color: SettingsModel.instance.challenges['allergens']!
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration:
                              SettingsModel.instance.challenges['allergens']!
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[0],
                  ),
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Naskenuj prvy produkt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                !SettingsModel.instance.challenges['firstScan']!
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                            decoration:
                                SettingsModel.instance.challenges['firstScan']!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Naskenuj první produkt a zjisti, či je bez alergenů',
                        style: TextStyle(
                          fontSize: 16,
                          color: SettingsModel.instance.challenges['firstScan']!
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration:
                              SettingsModel.instance.challenges['firstScan']!
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[1],
                  ),
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Zdielaj aplikaciu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                !SettingsModel.instance.challenges['shareApp']!
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                            decoration:
                                SettingsModel.instance.challenges['shareApp']!
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Zdielaj aplikaciu s priatelmi',
                        style: TextStyle(
                          fontSize: 16,
                          color: SettingsModel.instance.challenges['shareApp']!
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration:
                              SettingsModel.instance.challenges['shareApp']!
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[2],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  'Daily Challenges',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    panelOpen[index + 3] = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Naskenuj produkt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !widget.scanFinished
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            decoration: widget.scanFinished
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Naskenuj produkt a zisti, či je bez alergénov',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.scanFinished
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration: widget.scanFinished
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[3],
                  ),
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Prečítaj si článok',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !widget.blogFinished
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            decoration: widget.blogFinished
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Prečítaj si článok o alergénoch',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.blogFinished
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration: widget.blogFinished
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[4],
                  ),
                  ExpansionPanel(
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Prihlás sa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !widget.loginFinished
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            decoration: widget.loginFinished
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(
                        'Prihlás sa do aplikácie',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.loginFinished
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          decoration: widget.loginFinished
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[5],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
