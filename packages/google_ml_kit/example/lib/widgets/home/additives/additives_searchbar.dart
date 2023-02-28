import 'package:flutter/material.dart';

import '../../../models/jedalnicek_model.dart';
import '../../../models/settings_model.dart';
import 'additives_searchbar_result.dart';

class AdditivesSearchbar extends StatefulWidget {
  const AdditivesSearchbar({Key? key}) : super(key: key);
  @override
  _AdditivesSearchbarState createState() => _AdditivesSearchbarState();
}

class _AdditivesSearchbarState extends State<AdditivesSearchbar> {
  final SettingsModel settings = SettingsModel.instance;
  List<String> filteredJedalnicky = [];
  final jedalnicky = JedalnicekModel.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktuálny zoznam: ${settings.selectedList == 'default' ? 'Predvolený' : settings.selectedList.length > 10 ? '${settings.selectedList.substring(0, 10)}...' : settings.selectedList}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    if (SettingsModel.instance.selectedList != 'default') {
                      settings.selectedList = 'default';
                      settings.saveToFirebase();
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // search bar for new list
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        updateFilteredAditives(value);
                      });
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Zadajte názov zoznamu',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      contentPadding: EdgeInsets.only(left: 15, top: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              for (var i = 0; i < 3; i++)
                Column(
                  children: [
                    SearchBarResult(
                      name: filteredJedalnicky.length > (i + 1)
                          ? filteredJedalnicky[i]
                          : null,
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }

  void updateFilteredAditives(String hasToContain) {
    filteredJedalnicky.clear();
    for (var i = 0; i < jedalnicky.all.length; i++) {
      if (jedalnicky.all[i].contains(hasToContain)) {
        filteredJedalnicky.add(jedalnicky.all[i]);
      }
    }
  }
}
