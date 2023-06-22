import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/models/place.dart';
import 'package:flutter_place_with_riverpod/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceChangeNotifier extends ChangeNotifier {
  PlaceChangeNotifier({
    required String title,
    required File image,
    required PlaceLocation location,
  }) {
    place = Place(
      title: title,
      image: File.fromUri(Uri()),
      location: location,
    );
  }

  late Place place;

  void changePlace(Place place) {
    this.place = place;
    notifyListeners();
  }
}

final placeProvider = ChangeNotifierProvider<PlaceChangeNotifier>((ref) {
  final users = ref.watch(userPlacesProvider);

  if (users.isEmpty) {
    return PlaceChangeNotifier(
      title: '',
      image: File.fromUri(Uri()),
      location: const PlaceLocation(
        address: '',
        latitude: 0,
        longtitude: 0,
      ),
    );
  }

  return PlaceChangeNotifier(
    image: users[0].image,
    title: users[0].title,
    location: users[0].location,
  );
});
