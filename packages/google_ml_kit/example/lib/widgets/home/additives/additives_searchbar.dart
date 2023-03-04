import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  final dropdownController = TextEditingController();
  final jedalnicky = JedalnicekModel.instance;
  JedalnicekItem? selected;

  @override
  void initState() {
    selected = JedalnicekItem(settings.selectedList);
    super.initState();
  }

  @override
  void dispose() {
    dropdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<JedalnicekItem>> jedalnickyEntries =
        jedalnicky.all
            .map((e) => DropdownMenuEntry<JedalnicekItem>(
                  value: JedalnicekItem(e),
                  label: e,
                  enabled: e != settings.selectedList,
                ))
            .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Aktuálny zoznam: ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    settings.selectedList == 'default'
                        ? 'Predvolený'
                        : settings.selectedList.length > 10
                            ? '${settings.selectedList.substring(0, 10)}...'
                            : settings.selectedList,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.inversePrimary,
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
                    child: IconButton(
                      onPressed: () {
                        if (SettingsModel.instance.selectedList != 'default') {
                          settings.selectedList = 'default';
                          settings.saveToFirebase();
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
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
          child: DropdownMenu<JedalnicekItem>(
            initialSelection: selected,
            controller: dropdownController,
            enableSearch: true,
            enableFilter: true,
            menuHeight: 150,
            width: 250,
            leadingIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            dropdownMenuEntries: jedalnickyEntries,
            onSelected: (value) {
              if (value == null) return;
              settings.selectedList = value.label;
              settings.saveToFirebase();
              setState(() {
                selected = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class JedalnicekItem {
  final String label;

  JedalnicekItem(this.label);
}
