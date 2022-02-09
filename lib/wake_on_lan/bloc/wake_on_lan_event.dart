part of 'wake_on_lan_bloc.dart';

abstract class WakeOnLanEvent extends Equatable {
  const WakeOnLanEvent();

  @override
  List<Object> get props => [];
}

class WakeOnLanRequested extends WakeOnLanEvent {
  const WakeOnLanRequested({
    required this.ipv4,
    required this.macAddress,
  });

  final String ipv4;
  final String macAddress;

  @override
  List<Object> get props => [
        ipv4,
        macAddress,
      ];
}
