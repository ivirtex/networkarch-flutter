import 'package:network_arch/dns_lookup/data_provider/dns_lookup_api.dart';
import 'package:network_arch/dns_lookup/models/dns_lookup_response.dart';

class DnsLookupRepository {
  DnsLookupRepository({DnsLookupApi? api})
      : _dnsLookupApi = api ?? DnsLookupApi();

  final DnsLookupApi _dnsLookupApi;

  Future<DnsLookupResponse> lookup(String hostname, {required int type}) {
    if (hostname.isEmpty) {
      throw DnsLookupHostnameNotSpecified();
    }

    return _dnsLookupApi.lookup(hostname, type: type);
  }
}

class DnsLookupHostnameNotSpecified implements Exception {}
