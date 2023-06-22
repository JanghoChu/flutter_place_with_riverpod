import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_place_with_riverpod/models/place.dart';
import 'package:flutter_place_with_riverpod/providers/user_places.dart';

// mockito를 사용하여 프로바이더가 notify할 때의 값을 추적하기 위한 listeners 객체를 생성
class PlacesListener extends Mock {
  void call(List<Place>? previous, List<Place>? value);
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

  late UserPlacesNotifier userPlacesNotifier;
  late ProviderContainer container;
  late PlacesListener listener;

  Place place = Place(
    title: title,
    image: emptyImg,
    location: location,
  );

  group('user_places_notifier_test', () {
    setUp(() {
      userPlacesNotifier = UserPlacesNotifier();
    });
    test('addPlace_adds_place', () {
      userPlacesNotifier.addPlace(title2, emptyImg2, location2);

      expect(userPlacesNotifier.state.length, 1);
    });
  });

  group('user_place_provider_test', () {
    setUp(() {
      userPlacesNotifier = UserPlacesNotifier();
      container = ProviderContainer();
      listener = PlacesListener();
    });

    test("notifies listener when new place is added", () async {
      addTearDown(container.dispose);

      // 프로바이더를 관찰하고 값 변화를 검출
      container.listen<List<Place>>(
        userPlacesProvider,
        listener.call,
        fireImmediately: true,
      );

      // 리스너는 []을 기본값으로 호출
      verify(listener(null, [])).called(1);
      verifyNoMoreInteractions(listener);

      // Place를 추가
      container
          .read(userPlacesProvider.notifier)
          .addPlace(title, emptyImg, location);

      // 리스너는 [place]을 호출
      // ** place객체의 equals method가 구현돼야 동일 객체로 인식
      verify(listener([], [place])).called(1);
      verifyNoMoreInteractions(listener);
    });
  });
}
