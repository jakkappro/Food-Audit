import 'dart:io';

import 'package:event/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/allergens.dart';
import '../../../../../models/settings_model.dart';
import '../../../../../widgets/home/decorated_container.dart';
import '../../../../../widgets/settings/profile/body_dimensions.dart';
import '../../../../../widgets/settings/profile/index_displays.dart';
import '../../../../../widgets/settings/profile/name.dart';
import '../../../../../widgets/settings/profile/named_date_picker.dart';
import '../../../../../widgets/settings/profile/named_dropdown.dart';
import 'subsettings.dart';

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

    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      height: 780,
      child: Column(
        children: [
          DecoratedContainer(
            body: _buildBody(),
            width: width,
            height: 420,
            imageUrl: _getImageUrl(),
            leftDecoration: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SubSettings(),
                  ),
                );
              },
              child: const Icon(
                Icons.settings_outlined,
                size: 28,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Row(
              children: [
                Text(
                  'Moje intolerancie',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Row(
              children: [
                Text(
                  'Systém ťa bude automaticky upozorňovať ak bude pre\nteba produkt nevhodný',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22.0, right: 22.0),
            child: Wrap(
              spacing: 7.0,
              children: allergens
                  .map(
                    (e) => FilterChip(
                        label: Text(e),
                        showCheckmark: false,
                        avatar: const Icon(Icons.warning_amber_outlined),
                        selected: settings.allergens.contains(e),
                        selectedColor:
                            Theme.of(context).colorScheme.errorContainer,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                        onSelected: (bool b) {}),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_firstName $_lastName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Toto je tvoj profil',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
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
        Row(
          children: [
            Expanded(
              child: NamedDropdown(
                label: 'Pohlavie',
                value: _selectedGender!,
                items: const ['Muž', 'Žena'],
                onChanged: _updateGender,
              ),
            ),
            Expanded(
              child: NamedDatePicker(
                label: 'Dátum narodenia',
                value: settings.birthDate,
                onChanged: _updateDate,
                text: 'Zvoľte dátum',
              ),
            ),
          ],
        )
      ],
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
