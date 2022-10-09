// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

// Project imports:
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/whois/whois.dart';

class MockNetworkStatusRepository extends Mock
    implements NetworkStatusRepository {}

class MockPingRepository extends Mock implements PingRepository {}

class MockLanScannerRepository extends Mock implements LanScannerRepository {}

class MockIpGeoRepository extends Mock implements IpGeoRepository {}

class MockWhoisRepository extends Mock implements WhoisRepository {}

class MockDnsLookupRepository extends Mock implements DnsLookupRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    TargetPlatform platform = TargetPlatform.android,
    MockNavigator? navigator,
    NetworkStatusRepository? networkStatusRepository,
    PingRepository? pingRepository,
    LanScannerRepository? lanScannerRepository,
    IpGeoRepository? ipGeoRepository,
    WhoisRepository? whoisRepository,
    DnsLookupRepository? dnsLookupRepository,
  }) async {
    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: networkStatusRepository ?? MockNetworkStatusRepository(),
          ),
          RepositoryProvider.value(
            value: pingRepository ?? MockPingRepository(),
          ),
          RepositoryProvider.value(
            value: lanScannerRepository ?? MockLanScannerRepository(),
          ),
          RepositoryProvider.value(
            value: ipGeoRepository ?? MockIpGeoRepository(),
          ),
          RepositoryProvider.value(
            value: whoisRepository ?? MockWhoisRepository(),
          ),
          RepositoryProvider.value(
            value: dnsLookupRepository ?? MockDnsLookupRepository(),
          ),
        ],
        child: platform == TargetPlatform.iOS
            ? CupertinoApp(
                home: widget,
              )
            : MaterialApp(
                home: widget,
              ),
      ),
    );
  }
}
