import 'dart:io';

import 'package:event/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../models/settings_model.dart';
import '../../../../../widgets/settings/profile/body_dimensions.dart';
import '../../../../../widgets/settings/profile/index_displays.dart';
import '../../../../../widgets/settings/profile/name.dart';
import '../../../../../widgets/settings/profile/named_date_picker.dart';
import '../../../../../widgets/settings/profile/named_dropdown.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User? user;
  late String _firstName;
  late String _lastName;
  SettingsModel settings = SettingsModel.instance;
  double _bmi = 0;
  double _bmr = 0;
  String? _selectedGender;

  final heigthEvent = Event<Value<double>>();
  final weightEvent = Event<Value<double>>();

  final bmiEvent = Event<Value<double>>();
  final bmrEvent = Event<Value<double>>();

  @override
  void initState() {
    super.initState();
    if (SettingsModel.isAnonymous) {
      _firstName = 'Anonymous';
      _lastName = 'User';
      return;
    }
    user = FirebaseAuth.instance.currentUser!;
    _firstName = user!.displayName!.split(' ')[0];
    _lastName = user!.displayName!.split(' ')[1];
    heigthEvent.subscribe((args) {
      settings.height = args!.value;
      _calculateBmi();
      _calculateBmr();
      bmiEvent.broadcast(Value(_bmi / 40));
      bmrEvent.broadcast(Value(_bmr / 4000));
    });
    weightEvent.subscribe((args) {
      settings.weight = args!.value;
      _calculateBmi();
      _calculateBmr();
      bmiEvent.broadcast(Value(_bmi / 40));
      bmrEvent.broadcast(Value(_bmr / 4000));
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedGender ??= 'Muž';
    // calculate bmr
    _calculateBmr();

    // calculate bmi
    _calculateBmi();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        width: double.infinity,
        height: 780,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                if (SettingsModel.isAnonymous) {
                  return;
                }
                final newImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxWidth: 521,
                  maxHeight: 521,
                );

                if (newImage == null) {
                  return;
                }

                final ref =
                    FirebaseStorage.instance.ref().child('avatar/${user!.uid}');

                await ref.putFile(File(newImage.path));

                await user!.updatePhotoURL(await ref.getDownloadURL());
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
            IndexDisplays(
              _bmi,
              _bmr,
              bmiEvent,
              bmrEvent,
            ),
            const SizedBox(height: 20),
            Name(
              firstName: _firstName,
              lastName: _lastName,
              onChangedFirstName: onChangedFirstName,
              onChangedLastName: onChangedLastName,
            ),
            const SizedBox(height: 20),
            BodyDimensions(
              height: settings.height.toDouble() < 50
                  ? 50
                  : settings.height.toDouble() > 250
                      ? 250
                      : settings.height.toDouble(),
              weight: settings.weight.toDouble() < 30
                  ? 30
                  : settings.weight.toDouble() > 200
                      ? 200
                      : settings.weight.toDouble(),
              onChangedHeight: _updateHeight,
              onChangedWeight: _updateWeight,
              heightEvent: heigthEvent,
              weightEvent: weightEvent,
            ),
            const SizedBox(height: 20),
            NamedDatePicker(
                label: 'Datum narodenia',
                value: settings.birthDate != DateTime.parse('1800-02-27')
                    ? settings.birthDate
                    : DateTime.now(),
                text: settings.birthDate != DateTime.parse('1800-02-27')
                    ? DateFormat('dd.MM.yyyy').format(settings.birthDate)
                    : 'Zvoľte si dátum narodenia',
                onChanged: _updateDate),
            const SizedBox(height: 20),
            NamedDropDown(
              label: 'Pohlavie',
              value: _selectedGender!,
              onChanged: _updateGender,
              items: const ['Muž', 'Žena'],
            ),
          ],
        ),
      ),
    );
  }

  void _calculateBmi() {
    _bmi =
        settings.weight / ((settings.height / 100) * (settings.height / 100));
  }

  void _calculateBmr() {
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
  }

  String _getImageUrl() {
    return SettingsModel.isAnonymous
        ? 'https://i.pravatar.cc/100'
        : user!.photoURL ?? 'https://i.pravatar.cc/100';
  }

  Future<void> _updateGender(String value) async {
    _selectedGender = value;
    settings.isMale = _selectedGender!.toLowerCase() == 'muž';
    if (!SettingsModel.isAnonymous) {
      settings.saveToFirebase();
    }
  }

  Future<void> _updateDate(DateTime value) async {
    settings.birthDate = value;
    settings.age = DateTime.now().difference(settings.birthDate).inDays / 365;
    if (!SettingsModel.isAnonymous) {
      settings.saveToFirebase();
    }
  }

  Future<void> _updateHeight(String value) async {
    settings.height = double.parse(value);
    if (SettingsModel.isAnonymous) return;
    settings.saveToFirebase();
  }

  Future<void> _updateWeight(String value) async {
    settings.weight = double.parse(value);
    if (SettingsModel.isAnonymous) return;
    settings.saveToFirebase();
  }

  Future<void> onChangedFirstName(String value) async {
    if (SettingsModel.isAnonymous) {
      return;
    }
    await user!.updateDisplayName('$value $_lastName');
    setState(() {});
  }

  Future<void> onChangedLastName(String value) async {
    if (SettingsModel.isAnonymous) {
      return;
    }
    await user!.updateDisplayName('$_firstName $value');
    setState(() {});
  }
}
