import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:flutter_place_with_riverpod/global/dio_client.dart';

import 'test_dio_util.mocks.dart';

@GenerateMocks([DioClient])
MockDioClient mockDioClient = MockDioClient();

DioAdapter makeDioAdapter({
  required String url,
  data,
  queryParameters,
  Map<String, dynamic>? responseData,
  Map<String, dynamic>? headers,
  int statusCode = 200,
}) {
  Dio dio = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (headers != null && headers['Authorization'] != null) {
          options.headers['Authorization'] = headers['Authorization'];
        }
        return handler.next(options);
      },
    ));

  reset(mockDioClient);
  when(mockDioClient.dio).thenReturn(dio);

  final dioAdapter = DioAdapter(
    dio: dio,
    matcher: const FullHttpRequestMatcher(),
  );

  return dioAdapter
    ..onGet(
        url,
        headers: headers,
        queryParameters: queryParameters,
        (server) => server.reply(
              statusCode,
              responseData,
              delay: const Duration(seconds: 1),
            ))
    ..onPost(
        url,
        headers: headers,
        data: data,
        (server) => server.reply(
              statusCode,
              responseData,
              delay: const Duration(seconds: 1),
            ))
    ..onPatch(
        url,
        headers: headers,
        data: data,
        (server) => server.reply(
              statusCode,
              responseData,
              delay: const Duration(seconds: 1),
            ))
    ..onPut(
        url,
        headers: headers,
        data: data,
        (server) => server.reply(
              statusCode,
              responseData,
              delay: const Duration(seconds: 1),
            ))
    ..onDelete(
        url,
        headers: headers,
        data: data,
        (server) => server.reply(
              statusCode,
              responseData,
              delay: const Duration(seconds: 1),
            ));
}
