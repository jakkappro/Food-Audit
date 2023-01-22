import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/settings_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late String _firstName;
  late String _lastName;
  SettingsModel settings = SettingsModel.instance;
  double _bmi = 0;
  double _bmr = 0;
  Color _weightColor = Colors.green;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _firstName = user.displayName!.split(' ')[0];
    _lastName = user.displayName!.split(' ')[1];
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGender == null) {
      _selectedGender = 'Male';
    }
    // calculate bmr
    if (settings.isMale) {
      _bmr = 66.47 +
          13.75 * settings.weight +
          5.003 * settings.height -
          6.755 * settings.age;
    } else {
      _bmr = 655.1 +
          9.563 * settings.weight +
          1.85 * settings.height -
          4.676 * settings.age;
    }

    // calculate bmi
    _bmi = settings.weight / (settings.height / 100 * settings.height / 100);

    // set weight color
    if (_bmi > 30) {
      _weightColor = Colors.red;
    } else if (_bmi > 25) {
      _weightColor = Colors.orange;
    } else if (_bmi > 18.5) {
      _weightColor = Colors.green;
    } else {
      _weightColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: double.infinity,
        height: 780,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final newImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxWidth: 521,
                    maxHeight: 521);

                if (newImage == null) {
                  return;
                }

                final ref =
                    FirebaseStorage.instance.ref().child('avatar/${user.uid}');

                await ref.putFile(File(newImage.path));

                await user.updatePhotoURL(await ref.getDownloadURL());
              },
              child: Container(
                width: 120,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_getImageUrl()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Transform.rotate(
                        angle: -1.5708,
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(_weightColor),
                              value: _bmi > 0 ? _bmi / 40 : 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'BMI: ${_bmi.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Column(
                    children: [
                      Transform.rotate(
                        angle: -1.5708,
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(_weightColor),
                              value: _bmr > 0 ? _bmr / 4000 : 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'BMR: ${_bmr.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'First Name: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextField(
                        onSubmitted: (value) async => {
                          await user.updateDisplayName('$value $_lastName'),
                          setState(() {})
                        },
                        decoration: InputDecoration(
                          hintText: _firstName,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Last Name: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextField(
                        onSubmitted: (value) async => {
                          await user.updateDisplayName('$_firstName $value'),
                          setState(() {})
                        },
                        decoration: InputDecoration(
                          hintText: _lastName,
                          hintStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Heigth: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorColor: Colors.white,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      label: settings.height.toString(),
                      value: settings.height.toDouble() < 50
                          ? 50
                          : settings.height.toDouble() > 250
                              ? 250
                              : settings.height.toDouble(),
                      min: 50,
                      max: 250,
                      divisions: 200,
                      onChanged: (value) {
                        _updateHeight(value.ceil().toString());
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Weight: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      showValueIndicator: ShowValueIndicator.always,
                      valueIndicatorColor: Colors.white,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      label: settings.weight.toString(),
                      value: settings.weight.toDouble() < 30
                          ? 30
                          : settings.weight.toDouble() > 200
                              ? 200
                              : settings.weight.toDouble(),
                      min: 30,
                      max: 200,
                      divisions: 170,
                      onChanged: (value) {
                        _updateWeight(value.ceil().toString());
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Date of birdth: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Select date of birth",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            final dateOfBirth = await showDatePicker(
                              context: context,
                              initialDate: settings.birthDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                            );
                            if (dateOfBirth != null) {
                              setState(() {
                                settings.birthDate = dateOfBirth;
                                settings.age = DateTime.now()
                                        .difference(settings.birthDate)
                                        .inDays /
                                    365;
                                settings.saveToFirebase();
                              });
                            }
                          },
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Gender: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        items: ['Male', 'Female']
                            .map((gender) => DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender[0].toUpperCase() +
                                      gender.substring(1).toLowerCase()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedGender = value ?? _selectedGender;
                              settings.isMale =
                                  _selectedGender!.toLowerCase() == 'male';
                              settings.saveToFirebase();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrl() {
    return user.photoURL ??
        'https://dummyimage.com/100x100/cf1bcf/ffffff.jpg&text=BRUH+';
  }

  _updateHeight(String value) async {
    settings.height = double.parse(value);
    settings.saveToFirebase();
  }

  _updateWeight(String value) async {
    settings.weight = double.parse(value);
    settings.saveToFirebase();
  }
}
