import 'package:flutter/material.dart';

import '../decorated_container.dart';
import 'additives_searchbar.dart';

class Additives extends StatefulWidget {
  const Additives({Key? key, required this.onTap, required this.width})
      : super(key: key);

  final VoidCallback onTap;
  final double width;

  @override
  State<Additives> createState() => _AdditivesState();
}

class _AdditivesState extends State<Additives> {
  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Povolené a zakázané éčka',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const AdditivesSearchbar(),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: [
                    // button for creating new list with some text
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: widget.onTap,
                        child: Text(
                          'Vytvoriť nový zoznam',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      width: widget.width,
      height: 380,
    );
  }
}
