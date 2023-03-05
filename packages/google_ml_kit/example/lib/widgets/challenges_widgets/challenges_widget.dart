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
          padding: EdgeInsets.only(left: 15.0, right: 15, top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New User Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    panelOpen[index] = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Nastav si alergeny',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                SettingsModel.instance.challenges['allergens']!
                                    ? Colors.grey[600]
                                    : Colors.grey[900],
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
                              ? Colors.grey[400]
                              : Colors.grey[700],
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
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(
                          'Naskenuj prvy produkt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                SettingsModel.instance.challenges['firstScan']!
                                    ? Colors.grey[600]
                                    : Colors.grey[900],
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
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          decoration:
                              SettingsModel.instance.challenges['firstScan']!
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ),
                    isExpanded: panelOpen[1],
                  ),
                ],
              ),
              // TODO: finish this 
              ChallengeCard(
                title: 'Nastav si alergeny',
                description: 'Chod do nastavení a nastav si alergeny',
                completed: SettingsModel.instance.challenges['allergens']!,
              ),
              ChallengeCard(
                title: 'Naskenuj prvy produkt',
                description:
                    'Naskenuj první produkt a zjisti, či je bez alergenů',
                completed: SettingsModel.instance.challenges['firstScan']!,
              ),
              ChallengeCard(
                title: 'Zdielaj aplikaciu',
                description: 'Zdielaj aplikaciu s priatelmi',
                completed: SettingsModel.instance.challenges['shareApp']!,
              ),
              const SizedBox(height: 25),
              Text(
                'Daily Challenges',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              ChallengeCard(
                title: 'Prihlás sa',
                description: 'Prihlás sa do aplikácie',
                completed: widget.loginFinished,
              ),
              ChallengeCard(
                title: 'Naskenuj produkt',
                description: 'Naskenuj produkt a zisti, či je bez alergénov',
                completed: widget.scanFinished,
              ),
              ChallengeCard(
                title: 'Prečítaj si článok',
                description: 'Precitaj si článok o alergeniach',
                completed: widget.blogFinished,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
