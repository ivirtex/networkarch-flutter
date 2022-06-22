// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

part 'wake_on_lan_event.dart';
part 'wake_on_lan_state.dart';

class WakeOnLanBloc extends Bloc<WakeOnLanEvent, WakeOnLanState> {
  WakeOnLanBloc() : super(WakeOnLanInitial()) {
    on<WakeOnLanRequested>(_onRequested);
  }

  late IPv4Address _ipv4;
  bool _isValidIPv4 = true;

  late MACAddress _mac;
  bool _isValidMAC = true;

  Future<void> _onRequested(
    WakeOnLanRequested event,
    Emitter<WakeOnLanState> emit,
  ) async {
    if (IPv4Address.validate(event.ipv4)) {
      _ipv4 = IPv4Address(event.ipv4);
      _isValidIPv4 = true;
    } else {
      _isValidIPv4 = false;
    }

    if (MACAddress.validate(event.macAddress)) {
      _mac = MACAddress(event.macAddress);
      _isValidMAC = true;
    } else {
      _isValidMAC = false;
    }

    if (!_isValidIPv4 && !_isValidMAC) {
      emit(WakeOnLanIPandMACValidationFailure());

      return;
    } else if (!_isValidIPv4) {
      emit(WakeOnLanIPValidationFailure());

      return;
    } else if (!_isValidMAC) {
      emit(WakeOnLanMACValidationFailure());

      return;
    }

    final wol = WakeOnLAN(_ipv4, _mac);
    final packetBytes = wol.magicPacket();
    await wol.wake();

    emit(WakeOnLanSuccess(ipv4: _ipv4, mac: _mac, packetBytes: packetBytes));
  }
}
