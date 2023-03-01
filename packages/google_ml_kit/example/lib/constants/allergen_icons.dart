import 'package:flutter/material.dart';

final Map<String, List<Widget>> allergenIcons = {
    'Arašidy': [
      Image.asset('assets/allergens/peanut.png'),
      Image.asset('assets/allergens/peanut-free.png'),
    ],
    'Horčica': [
      Image.asset('assets/allergens/mustard.png'),
      Image.asset('assets/allergens/mustard.png'),
    ],
    'Mlieko': [
      Image.asset('assets/allergens/milk.png'),
      Image.asset('assets/allergens/dairy-free.png'),
    ],
    'Morské plody': [
      Image.asset('assets/allergens/shellfish.png'),
      Image.asset('assets/allergens/no-seafood.png'),
    ],
    'Orechy': [
      Image.asset('assets/allergens/walnut.png'),
      Image.asset('assets/allergens/nut-free.png'),
    ],
    'Pšenica': [
      Image.asset('assets/allergens/gluten.png'),
      Image.asset('assets/allergens/gluten-free.png'),
    ],
    'Ryby': [
      Image.asset('assets/allergens/fish.png'),
      Image.asset('assets/allergens/no-fish.png'),
    ],
    'Sezam': [
      Image.asset('assets/allergens/sesame.png'),
      Image.asset('assets/allergens/sesame.png'),
    ],
    'Sója': [
      Image.asset('assets/allergens/soybean.png'),
      Image.asset('assets/allergens/soy-free.png'),
    ],
    'Vajcia': [
      Image.asset('assets/allergens/egg.png'),
      Image.asset('assets/allergens/egg-free.png'),
    ]
  };