enum IpStatus { inital, loading, success, error }

class ExtIpModel {
  ExtIpModel({
    required this.status,
    required this.ip,
  });

  final IpStatus status;
  final String ip;
}
