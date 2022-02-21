// Project imports:
import 'package:network_arch/whois/data_provider/whois_api.dart';

class WhoisRepository {
  WhoisRepository({WhoisApi? api}) : _whoisApi = api ?? WhoisApi();

  final WhoisApi _whoisApi;

  Future<String> getWhois(String domain) {
    if (domain.isEmpty) {
      throw WhoisNoDomainSpecifiedException();
    }

    return _whoisApi.getWhois(domain);
  }
}

class WhoisNoDomainSpecifiedException implements Exception {}
