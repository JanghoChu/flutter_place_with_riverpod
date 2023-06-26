import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/models/place.dart';
import 'package:flutter_place_with_riverpod/providers/dio_provider.dart';
import 'package:flutter_place_with_riverpod/providers/location_provider.dart';
import 'package:flutter_place_with_riverpod/widgets/location_jnput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';

import '../mock_util.dart';
import '../test_dio_util.dart';

void main() {
  const String apiKey = 'AIzaSyASjh__HkjeWvOVKvEotl-UwF0ZA052g1o';
  const double lat = 123.123;
  const double lng = 345.345;
  const String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

  late PlaceLocation getLocation;

  Widget locationInput = ProviderScope(
    overrides: [
      locationProvider.overrideWith((ref) => mockLocation),
      dioClientProvider.overrideWith((ref) => mockDioClient)
    ],
    child: MaterialApp(
      home: Scaffold(
        body: LocationInput(
          onSelectedLocation: (PlaceLocation location) {
            getLocation = location;
          },
        ),
      ),
    ),
  );

  group(
    'location_jnput_test',
    () {
      setUp(() async {
        when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
        when(mockLocation.hasPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        when(mockLocation.getLocation())
            .thenAnswer((_) async => mockLocationData);

        when(mockLocationData.latitude).thenReturn(lat);
        when(mockLocationData.longitude).thenReturn(lng);

        makeDioAdapter(url: url, responseData: {
          'results': [
            {'formatted_address': 'formatted_address'}
          ]
        });
      });

      testWidgets('creates', (WidgetTester tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(locationInput);

          await tester.tap(find.byKey(const ValueKey("getCurrentKey")));

          await Future.delayed(const Duration(milliseconds: 1500));

          expect(getLocation.latitude, lat);
          expect(getLocation.longtitude, lng);
        });
      });
    },
  );
}
