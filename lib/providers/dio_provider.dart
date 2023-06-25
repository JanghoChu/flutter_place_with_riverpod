import 'package:flutter_place_with_riverpod/global/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
