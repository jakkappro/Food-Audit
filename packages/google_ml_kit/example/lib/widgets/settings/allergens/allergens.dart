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
        Container(
          color: const Color.fromRGBO(105, 140, 17, 1),
          child: Row(
            children: const [
              SizedBox(width: 20),
              Text(
                'Allergens:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: const Color.fromRGBO(105, 140, 17, 1),
          child: Column(
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
                      backgroundColor: Colors.white,
                      selectedColor: Colors.white,
                      showCheckmark: false,
                      label: SizedBox(
                        width: double.infinity,
                        height: 35,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            allergen,
                            style: TextStyle(
                              color: settings.allergens.contains(allergen)
                                  ? const Color.fromRGBO(128, 157, 54, 1)
                                  : const Color.fromRGBO(158, 166, 179, 1),
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
        ),
      ],
    );
  }
}
