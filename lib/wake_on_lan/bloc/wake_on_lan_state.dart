part of 'wake_on_lan_bloc.dart';

abstract class WakeOnLanState {
  const WakeOnLanState();
}

class WakeOnLanInitial extends WakeOnLanState {}

class WakeOnLanSuccess extends WakeOnLanState {
  const WakeOnLanSuccess({
    required this.ipv4,
    required this.mac,
    required this.packetBytes,
  });

  final IPAddress ipv4;
  final MACAddress mac;
  final List<int> packetBytes;
}

class WakeOnLanIPValidationFailure extends WakeOnLanState {}

class WakeOnLanMACValidationFailure extends WakeOnLanState {}

class WakeOnLanIPandMACValidationFailure extends WakeOnLanState {}
