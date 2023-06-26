import 'package:location/location.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_place_with_riverpod/global/dio_client.dart';

import 'mock_util.mocks.dart';

@GenerateMocks([
  DioClient,
  Location,
  LocationData,
])
MockDioClient mockDioClient = MockDioClient();
MockLocation mockLocation = MockLocation();
MockLocationData mockLocationData = MockLocationData();
