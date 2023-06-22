import 'dart:io';

import 'package:flutter_place_with_riverpod/providers/place_provider.dart';
import 'package:flutter_place_with_riverpod/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_place_with_riverpod/models/place.dart';

class MockPlaceListener extends Mock {
  void call(PlaceChangeNotifier? previous, PlaceChangeNotifier value);
}

void main() {
  const title = 'title';
  final emptyImg = File.fromUri(Uri());
  const location = PlaceLocation(
    address: "address",
    latitude: 123,
    longtitude: 123,
  );

  const title2 = 'title2';
  final emptyImg2 = File.fromUri(Uri());
  const location2 = PlaceLocation(
    address: "address2",
    latitude: 12,
    longtitude: 23,
  );

  Place place = Place(
    title: title,
    image: emptyImg,
    location: location,
  );

  late PlaceChangeNotifier placeChangeNotifier;
  late ProviderContainer container;
  late MockPlaceListener listener;

  group('place_change_notifier_test', () {
    setUp(() {
      placeChangeNotifier = PlaceChangeNotifier(
          title: '',
          image: emptyImg,
          location: const PlaceLocation(
            address: '',
            latitude: 0,
            longtitude: 0,
          ));
    });

    test('changesPlace changes place', () async {
      placeChangeNotifier.changePlace(place);

      expect(placeChangeNotifier.place, place);
    });
  });

  group('place_provider_test', () {
    setUp(() {
      container = ProviderContainer();
      listener = MockPlaceListener();
      placeChangeNotifier = PlaceChangeNotifier(
          title: '',
          image: File.fromUri(Uri()),
          location: const PlaceLocation(
            address: '',
            latitude: 0,
            longtitude: 0,
          ));
    });

    test('notifies listener when place is changed', () async {
      addTearDown(container.dispose);

      // 프로바이더를 관찰하고 값 변화를 검출
      // container.listen<PlaceChangeNotifier>(
      //   placeProvider,
      //   listener.call,
      //   fireImmediately: true,
      // );

      // 리스너는 placeChangeNotifier 을 기본값으로 호출
      // verify(listener(null, placeChangeNotifier)).called(1);
      // verifyNoMoreInteractions(listener);

      // container
      //     .read(userPlacesProvider.notifier)
      //     .addPlace(title, emptyImg, location);

      // // Place를 변경
      // container.read(placeProvider).changePlace(place);

      // 리스너는 [place]을 호출
      // ** place객체의 equals method가 구현돼야 동일 객체로 인식
      // verify(listener(placeChangeNotifier, placeChangeNotifier)).called(1);
      // verifyNoMoreInteractions(listener);
    }, skip: true);
  });
}
