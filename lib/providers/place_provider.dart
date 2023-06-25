import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_place_with_riverpod/models/place.dart';
import 'package:flutter_place_with_riverpod/providers/dio_provider.dart';
import 'package:flutter_place_with_riverpod/providers/user_places_provider.dart';

class PlaceChangeNotifier extends ChangeNotifier {
  PlaceChangeNotifier(
    this._ref, {
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
  final Ref _ref;
  late Place place;

  void changePlace(Place place) {
    this.place = place;
    notifyListeners();
  }

  fetchPlace() async {
    final client = _ref.read(dioClientProvider);

    final response = await client.dio.get(
      'http://localhost:8899/users',
      queryParameters: {'name': 'name'},
    );
    print(response.data);
  }
}

final placeProvider = ChangeNotifierProvider<PlaceChangeNotifier>((ref) {
  final users = ref.watch(userPlacesProvider);

  if (users.isEmpty) {
    return PlaceChangeNotifier(
      ref,
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
    ref,
    image: users[0].image,
    title: users[0].title,
    location: users[0].location,
  );
});
