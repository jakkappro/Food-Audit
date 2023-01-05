import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/settings_model.dart';

class FoodPreferencesPage extends StatefulWidget {
  @override
  _FoodPreferencesState createState() => _FoodPreferencesState();
}

class _FoodPreferencesState extends State<FoodPreferencesPage> {
  SettingsModel settings = SettingsModel.instance;
  List<String> sugestedAlergens = [];
  
  Future<void> _removeAlergen(String alergen) async {
    setState(() {
      settings.allergens.remove(alergen);
    });
  }

  Future<void> _addAlergen(String alergen) async {
    settings.allergens.add(alergen);
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(56, 45, 62, 1),
        appBar: AppBar(
          title: const Text('Food preferences', style: TextStyle(fontSize: 30)),
          backgroundColor: const Color.fromRGBO(56, 45, 62, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 25,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color.fromRGBO(66, 58, 76, 1),
              ),
              child: ExpansionTile(
                title: const Text(
                  'Alergens',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: settings.allergens.length * 50.0,
                    child: ListView.builder(
                      itemCount: settings.allergens.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromRGBO(66, 58, 76, 1),
                          ),
                          width: double.infinity,
                          height: 50,
                          child: ListTile(
                            title: Text(settings.allergens[index]),
                            leading: const Icon(Icons.local_drink),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _removeAlergen(settings.allergens[index]);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ExpansionTile(
                    initiallyExpanded: true,
                    trailing: Icon(
                      Icons.arrow_back,
                      size: 0.0,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: TextField(
                              onChanged: _getReconemdedAlergens,
                              decoration: InputDecoration(
                                hintText: 'Add new alergen',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: sugestedAlergens.length > 3
                            ? 150
                            : sugestedAlergens.length * 50.0,
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ListTile(
                                  title: Text(sugestedAlergens[index]),
                                  onTap: () {
                                    _addAlergen(sugestedAlergens[index]);
                                  },
                                  trailing: null,
                                ),
                              );
                            },
                            itemCount: sugestedAlergens.length > 3
                                ? 3
                                : sugestedAlergens.length),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      await settings.saveToFirebase();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _getReconemdedAlergens(String value) {
    setState(() {
      sugestedAlergens = settings.allAlergens.keys
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
