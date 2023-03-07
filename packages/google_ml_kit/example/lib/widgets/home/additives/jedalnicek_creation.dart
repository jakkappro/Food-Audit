// TODO: somehow rework this pls :(

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_choices/search_choices.dart';

import '../../../models/aditives_model.dart';
import '../../../models/jedalnicek_model.dart';
import '../../../models/settings_model.dart';
import '../../settings/profile/named_text_field.dart';

class JedalnicekCreation extends StatefulWidget {
  @override
  _JedalniceCreationState createState() => _JedalniceCreationState();
}

class _JedalniceCreationState extends State<JedalnicekCreation> {
  final User? user = FirebaseAuth.instance.currentUser;
  final settings = SettingsModel.instance;
  bool challengesVisible = false;
  final List<String> bannedAditives = [];
  final List<String> allAditives = [];
  final List<String> filteredAditives = [];
  final nameController = TextEditingController();
  List<int> selectedItemsMultiCustomDisplayDialog = [];

  @override
  void initState() {
    super.initState();
    // asing all aditives to a list
    for (var i = 0; i < AditivesModel.instance.aditivs.length; i++) {
      allAditives.add(AditivesModel.instance.aditivs.keys.elementAt(i));
    }
    filteredAditives.addAll(allAditives);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // inputfield for name of the diet
                    const SizedBox(
                      height: 20,
                    ),
                    NamedTextField(
                      label: 'Dieta',
                      hintText: 'Nazov diety',
                      onSubmited: (String value) async {},
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    // searchbar
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: SearchChoices.multiple(
                        items: allAditives
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        selectedItems:
                            bannedAditives.map(allAditives.indexOf).toList(),
                        hint: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Select any'),
                        ),
                        searchHint: 'Select any',
                        onChanged: (value) {
                          setState(() {
                            selectedItemsMultiCustomDisplayDialog = value;
                          });
                        },
                        displayItem: (item, selected) {
                          return Row(
                            children: [
                              selected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.grey,
                                    ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: item,
                              ),
                            ],
                          );
                        },
                        selectedValueWidgetFn: (item) {
                          return Center();
                        },
                        doneButton: (selectedItemsDone, doneContext) {
                          return ElevatedButton(
                            onPressed: () {
                              Navigator.pop(doneContext);
                              setState(() {
                                bannedAditives.clear();
                                selectedItemsDone.forEach((element) {
                                  bannedAditives.add(allAditives[element]);
                                });
                              });
                            },
                            child: const Text('Ok'),
                          );
                        },
                        closeButton: null,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        searchFn: (String keyword, items) {
                          List<int> ret = [];
                          if (items != null && keyword.isNotEmpty) {
                            keyword.split(' ').forEach((k) {
                              int i = 0;
                              items.forEach((item) {
                                if (!ret.contains(i) &&
                                    k.isNotEmpty &&
                                    (item.value
                                        .toString()
                                        .toLowerCase()
                                        .contains(k.toLowerCase()))) {
                                  ret.add(i);
                                }
                                i++;
                              });
                            });
                          }
                          if (keyword.isEmpty) {
                            ret = Iterable<int>.generate(items.length).toList();
                          }
                          return (ret);
                        },
                        clearIcon: const Icon(Icons.clear_all),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        label: 'Search',
                        underline: Container(
                          height: 1.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.teal, width: 3.0),
                            ),
                          ),
                        ),
                        iconDisabledColor: Colors.brown,
                        iconEnabledColor: Colors.indigo,
                        dropDownDialogPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0,
                        ),
                        isExpanded: true,
                        clearSearchIcon: const Icon(
                          Icons.backspace,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        children: [
                          Text('Zakazane aditiva'),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width,
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                for (var i = 0; i < bannedAditives.length; i++)
                                  SizedBox(
                                    width: 160,
                                    height: 50,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                bannedAditives.removeAt(i);
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 160,
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'aditivum ${bannedAditives[i]}',
                                              style: const TextStyle(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // confirm button
                    SizedBox(
                      width: width,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width - 160,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async {
                                // create new document in firebase with banned aditives and name and user id
                                await FirebaseFirestore.instance
                                    .collection('jedalnicek')
                                    .doc(nameController.text)
                                    .set({
                                  'bannedAditives': bannedAditives,
                                  'user': user!.displayName
                                });
                                await JedalnicekModel.instance
                                    .loadFromFirebase();
                              },
                              child: const Text('Vytvoriť'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // method that will create aditiv Widget with name and plus icon
  Widget aditivWidget(String name) {
    return SizedBox(
      width: 160,
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                setState(() {
                  // check if aditiv is already in banned aditives
                  if (bannedAditives.contains(name)) {
                    return;
                  }
                  bannedAditives.add(name);
                });
              },
            ),
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
