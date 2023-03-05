import 'package:flutter/material.dart';

import '../../../constants/allergen_icons.dart';
import '../../../constants/allergens.dart';
import '../../../models/settings_model.dart';

class Allergens extends StatefulWidget {
  @override
  _AllergensState createState() => _AllergensState();
}

class _AllergensState extends State<Allergens> {
  SettingsModel settings = SettingsModel.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(width: 20),
            Text(
              'Allergens:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: allergens
              .map(
                (allergen) => Container(
                  width: double.infinity,
                  height: 60,
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: FilterChip(
                    avatar: Container(
                      child: allergenIcons[allergen]![
                          settings.allergens.contains(allergen) ? 0 : 1],
                    ),
                    showCheckmark: true,
                    label: SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          allergen,
                          style: TextStyle(
                            color: settings.allergens.contains(allergen)
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    selected: settings.allergens.contains(allergen),
                    onSelected: (selected) {
                      setState(
                        () {
                          if (selected) {
                            settings.allergens.add(allergen);
                          } else {
                            settings.allergens.remove(allergen);
                          }
                          settings.remapAllergicOn();
                          if (!settings.challenges['allergens']!) {
                            settings.challenges['allergens'] = true;
                          }
                          settings.saveToFirebase();
                        },
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
