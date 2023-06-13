import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/screens/add_place_screen.dart';
import 'package:flutter_place_with_riverpod/widgets/place_list.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()),
            ),
          )
        ],
      ),
      body: const PlaceList(places: []),
    );
  }
}
