import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../verify_email.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late String _firstName;
  late String _lastName;
  late String _height;
  late String _weight;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _firstName = user.displayName!.split(' ')[0];
    _lastName = user.displayName!.split(' ')[1];
    _height = '0';
    _weight = '0';

    try {
      FirebaseFirestore.instance
          .collection('userData')
          .doc(user.uid)
          .get()
          .then((value) {
        _height = value.data()!['height'].toString();
        _weight = value.data()!['weight'].toString();
        setState(() {
          _height = _height;
          _weight = _weight;
        });
      });
    } catch (e) {
      print('/n/n/n/n/n/n/nError: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(56, 45, 62, 1),
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(fontSize: 30)),
          backgroundColor: Color.fromRGBO(56, 45, 62, 1),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 25,
            onPressed: () async {
              auth.currentUser!.reload();
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
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

                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('avatar/${user.uid}');

                  await ref.putFile(File(newImage.path));

                  await user.updatePhotoURL(await ref.getDownloadURL());
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_getImageUrl()),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(66, 58, 76, 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'First Name: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
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
                            hintStyle: TextStyle(
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
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(66, 58, 76, 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Last Name: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
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
                            hintStyle: TextStyle(
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
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(66, 58, 76, 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Heigth: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) async => _updateHeight(value),
                          decoration: InputDecoration(
                            hintText: _height,
                            hintStyle: TextStyle(
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
              SizedBox(height: 20),
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(66, 58, 76, 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'Weight: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) async => _updateWeight(value),
                          decoration: InputDecoration(
                            hintText: _weight,
                            hintStyle: TextStyle(
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
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        await auth.currentUser!.reload();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImageUrl() {
    return user.photoURL ??
        'https://dummyimage.com/100x100/cf1bcf/ffffff.jpg&text=BRUH+';
  }

  _updateHeight(String value) async {
    final doc = FirebaseFirestore.instance.collection('userData').doc(user.uid);
    try {
      await doc.update({'height': double.parse(value)});
    } catch (e) {
      doc.set({'height': double.parse(value), 'weight': 0.0});
    }
  }

  _updateWeight(String value) async {
    final doc = FirebaseFirestore.instance.collection('userData').doc(user.uid);
    try {
      await doc.update({'weight': double.parse(value)});
    } catch (e) {
      doc.set({'height': 0.0, 'weight': double.parse(value)});
    }
  }
}
