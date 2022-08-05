// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:network_arch/dns_lookup/bloc/bloc.dart';

void main() {
  group('DnsLookupEvent', () {
    group('DnsLookupRequested', () {
      const request = DnsLookupRequested(
        hostname: 'google.com',
        type: 1,
      );

      test('supports value equality', () {
        expect(
          request,
          equals(request),
        );
      });

      test('props are correct', () {
        expect(
          request.props,
          equals(<Object?>['google.com', 1]),
        );
      });
    });
  });
}
