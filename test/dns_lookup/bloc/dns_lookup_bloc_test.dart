import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';

class MockDnsLookupRepository extends Mock implements DnsLookupRepository {}

void main() {
  group('DnsLookupBloc', () {
    final DnsLookupRepository dnsLookupRepository = MockDnsLookupRepository();

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

    DnsLookupBloc buildBloc() => DnsLookupBloc(dnsLookupRepository);

    group('bloc constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(DnsLookupInitial()));
      });
    });

    group('DnsLookupRequested', () {
      blocTest<DnsLookupBloc, DnsLookupState>(
        'emits DnsLookupLoadInProgress and DnsLookupLoadSuccess when '
        'DnsLookupRequested is added',
        setUp: () {
          when(
            () => dnsLookupRepository.lookup('google.com', type: 1),
          ).thenAnswer((_) => Future.value(dnsLookupResponse));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const DnsLookupRequested(hostname: 'google.com', type: 1),
        ),
        verify: (_) {
          verify(() => dnsLookupRepository.lookup('google.com', type: 1))
              .called(1);
        },
        expect: () => <DnsLookupState>[
          DnsLookupLoadInProgress(),
          const DnsLookupLoadSuccess(dnsLookupResponse),
        ],
      );

      blocTest<DnsLookupBloc, DnsLookupState>(
        'emits DnsLookupLoadInProgress and DnsLookupLoadFailure when '
        'DnsLookupRequested is added and DnsLookupRepository throws an exception',
        setUp: () {
          when(
            () => dnsLookupRepository.lookup('', type: 1),
          ).thenThrow(DnsLookupHostnameNotSpecified());
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const DnsLookupRequested(hostname: '', type: 1),
        ),
        verify: (_) {
          verify(() => dnsLookupRepository.lookup('', type: 1)).called(1);
        },
        expect: () => <DnsLookupState>[
          DnsLookupLoadInProgress(),
          DnsLookupLoadFailure(),
        ],
      );
    });
  });
}
