import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:network_arch/dns_lookup/dns_lookup.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('DnsLookupApi', () {
    final http.Client client = MockHttpClient();

    const dnsUrl = 'https://dns.google.com/resolve';

    const dnsLookupResponse = DnsLookupResponse(
      0,
      [
        DnsQuestion('google.com', 1),
      ],
      [
        DnsRecord('google.com', 1, 221, '142.250.186.206'),
      ],
      null,
    );

    const failedDnsLookupResponse = DnsLookupResponse(
      -1,
      [
        DnsQuestion('google.com', 1),
      ],
      [],
      null,
    );

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    DnsLookupApi createApi() => DnsLookupApi(client: client);

    group('constructor', () {
      test('works properly', () {
        expect(createApi, returnsNormally);
      });

      test('creates http client instance in initializer if not provided', () {
        expect(DnsLookupApi.new, isNotNull);
      });
    });

    group('lookup', () {
      final api = createApi();

      const target = 'google.com';
      final targetUri = Uri.parse('$dnsUrl?name=$target&type=1');

      when(() => client.get(targetUri)).thenAnswer(
        (_) => Future.value(
          http.Response(
            jsonEncode(dnsLookupResponse.toJson()),
            200,
          ),
        ),
      );

      test('correctly creates URI and makes http request', () async {
        try {
          await api.lookup(target, type: 1);
        } catch (e) {
          fail('Unexpected exception: $e');
        }

        verify(() => client.get(targetUri)).called(1);
      });

      test('returns DnsLookupResponse on valid http response', () async {
        expect(
          await api.lookup(target, type: 1),
          equals(dnsLookupResponse),
        );

        verify(() => client.get(targetUri)).called(1);
      });

      test('throws DnsLookupRequestFailure on http request failure', () async {
        when(() => client.get(targetUri)).thenThrow(Exception());

        expect(
          () => api.lookup(target, type: 1),
          throwsA(isA<DnsLookupRequestFailure>()),
        );

        verify(() => client.get(targetUri)).called(1);
      });

      test('throws DnsLookupRequestFailure on non-200 response', () {
        when(() => client.get(any())).thenAnswer(
          (_) => Future.value(
            http.Response(
              '{}',
              404,
            ),
          ),
        );

        expect(
          () => api.lookup(target, type: 1),
          throwsA(isA<DnsLookupRequestFailure>()),
        );

        verify(() => client.get(targetUri)).called(1);
      });

      test(
        'throws DnsLookupJsonDecodeFailure on invalid JSON structure',
        () {
          when(() => client.get(any())).thenAnswer(
            (_) => Future.value(
              http.Response(
                '{invalid}',
                200,
              ),
            ),
          );

          expect(
            () => api.lookup(target, type: 1),
            throwsA(isA<DnsLookupJsonDecodeFailure>()),
          );

          verify(() => client.get(targetUri)).called(1);
        },
      );

      test('throws DnsLookupNotFound on non-0 status or null answer', () {
        when(() => client.get(targetUri)).thenAnswer(
          (_) => Future.value(
            http.Response(
              jsonEncode(failedDnsLookupResponse.toJson()),
              200,
            ),
          ),
        );

        expect(
          () => api.lookup(target, type: 1),
          throwsA(isA<DnsLookupNotFound>()),
        );

        verify(() => client.get(targetUri)).called(1);
      });
    });
  });
}
