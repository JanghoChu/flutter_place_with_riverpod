import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_place_with_riverpod/providers/place_provider.dart';
import 'package:flutter_place_with_riverpod/providers/user_places.dart';
import 'package:flutter_place_with_riverpod/models/place.dart';

import 'custom_mock_ref.dart';

class MockPlaceListener extends Mock {
  void call(PlaceChangeNotifier? previous, PlaceChangeNotifier? value);
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
  late UserPlacesNotifier userPlacesNotifier;
  late ProviderContainer container;
  late MockPlaceListener mockPlacelistener;

  late Place addedPlace;

  listener(PlaceChangeNotifier? previous, PlaceChangeNotifier? value) {
    if (value != null) {
      addedPlace = value.place;
    }
  }

  group('place_change_notifier_test', () {
    setUp(() {
      placeChangeNotifier = PlaceChangeNotifier(
        CustomMockRef(),
        title: '',
        image: emptyImg,
        location: const PlaceLocation(
          address: '',
          latitude: 0,
          longtitude: 0,
        ),
      );
    });

    test('changesPlace changes place', () async {
      placeChangeNotifier.changePlace(place);

      expect(placeChangeNotifier.place, place);
    });
  });

  group('place_provider_test', () {
    setUp(() {
      userPlacesNotifier = UserPlacesNotifier();
      mockPlacelistener = MockPlaceListener();

      container = ProviderContainer(
        overrides: [
          userPlacesProvider.overrideWith((ref) => userPlacesNotifier)
        ],
      );
    });

    test(
        'creates new placeChangeNotifier with last Place of userPlacesNotifier',
        () async {
      addTearDown(container.dispose);

      userPlacesNotifier.addPlace(title, emptyImg, location);

      expect(container.read(placeProvider).place.title, title);

      userPlacesNotifier.addPlace(title2, emptyImg2, location2);

      expect(container.read(placeProvider).place.title, title2);
    });

    test('notifies when user\'s places are added', () async {
      addTearDown(container.dispose);

      // 프로바이더를 관찰하고 값 변화를 검출
      container.listen<PlaceChangeNotifier>(
        placeProvider,
        mockPlacelistener,
        fireImmediately: true,
      );

      // 최초 생성시 이벤트 발생
      verify(mockPlacelistener(
        any, // null은 any로 처리해야 오류가 발생하지 않음
        argThat(isA<PlaceChangeNotifier>()),
      )).called(1);
      verifyNoMoreInteractions(mockPlacelistener);

      // userPlaces에 새로운 장소 추가
      container
          .read(userPlacesProvider.notifier)
          .addPlace(title2, emptyImg2, location2);

      // 장소 추가 후 placePovider를 한번 읽어야 이벤트를 listen함
      container.read(placeProvider);

      // 새로운 장소 추가 시 이벤트 발생
      verify(mockPlacelistener.call(
        argThat(isA<PlaceChangeNotifier>()),
        argThat(isA<PlaceChangeNotifier>()),
      )).called(1);
    });

    test('updates Place when user\'s places are added', () async {
      addTearDown(container.dispose);

      // 프로바이더를 관찰하고 값 변화를 검출
      container.listen<PlaceChangeNotifier>(
        placeProvider,
        listener.call,
        fireImmediately: true,
      );

      expect(addedPlace.title, isEmpty);

      // userPlaces에 새로운 장소 추가
      container
          .read(userPlacesProvider.notifier)
          .addPlace(title2, emptyImg2, location2);

      // 장소 추가 후 placePovider를 읽어야 이벤트를 listen함
      container.read(placeProvider);

      expect(addedPlace.title, title2);
    });
  });
}
