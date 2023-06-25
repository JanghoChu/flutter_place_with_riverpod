import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/providers/user_places_provider.dart';
import 'package:flutter_place_with_riverpod/screens/add_place_screen.dart';
import 'package:flutter_place_with_riverpod/widgets/place_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/place.dart';
import '../providers/place_provider.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPlaces = ref.watch(userPlacesProvider);
    final place = ref.watch(placeProvider);

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
        body: PlaceList(places: userPlaces),
        bottomNavigationBar: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Place'),
          onPressed: () async {
            await ref.read(placeProvider).fetchPlace();
            // ref.read(placeProvider).changePlace(Place(
            //     title: "123",
            //     image: File.fromUri(Uri()),
            //     location: const PlaceLocation(
            //       address: "address",
            //       latitude: 123,
            //       longtitude: 123,
            //     )));
          },
        ));
  }
}
