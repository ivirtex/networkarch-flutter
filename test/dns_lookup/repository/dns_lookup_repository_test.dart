import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';

class MockDnsLookupApi extends Mock implements DnsLookupApi {}

void main() {
  group('DnsLookupRepository', () {
    final DnsLookupApi dnsLookupApi = MockDnsLookupApi();

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

    setUp(() {
      when(
        () => dnsLookupApi.lookup('google.com', type: 1),
      ).thenAnswer((_) => Future.value(dnsLookupResponse));
    });

    DnsLookupRepository createRepository() =>
        DnsLookupRepository(api: dnsLookupApi);

    group('constructor', () {
      test('works properly', () {
        expect(createRepository, returnsNormally);
      });

      test('creates api instance in initializer if not provided', () {
        expect(DnsLookupRepository.new, isNotNull);
      });
    });

    group('lookup', () {
      final repository = createRepository();

      test('makes correct api request', () {
        expect(
          repository.lookup('google.com', type: 1),
          completion(equals(dnsLookupResponse)),
        );

        verify(() => dnsLookupApi.lookup('google.com', type: 1)).called(1);
      });

      test('throws DnsLookupHostnameNotSpecified when hostname is empty', () {
        expect(
          () => repository.lookup('', type: 1),
          throwsA(isA<DnsLookupHostnameNotSpecified>()),
        );

        verifyNever(() => dnsLookupApi.lookup('', type: 1));
      });
    });
  });
}
