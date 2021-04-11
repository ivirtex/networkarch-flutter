// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConnectivityStore on _ConnectivityStore, Store {
  final _$connectivityStreamAtom =
      Atom(name: '_ConnectivityStore.connectivityStream');

  @override
  ObservableStream<ConnectivityResult> get connectivityStream {
    _$connectivityStreamAtom.reportRead();
    return super.connectivityStream;
  }

  @override
  set connectivityStream(ObservableStream<ConnectivityResult> value) {
    _$connectivityStreamAtom.reportWrite(value, super.connectivityStream, () {
      super.connectivityStream = value;
    });
  }

  final _$networkInterfacesAtom =
      Atom(name: '_ConnectivityStore.networkInterfaces');

  @override
  List<NetworkInterface> get networkInterfaces {
    _$networkInterfacesAtom.reportRead();
    return super.networkInterfaces;
  }

  @override
  set networkInterfaces(List<NetworkInterface> value) {
    _$networkInterfacesAtom.reportWrite(value, super.networkInterfaces, () {
      super.networkInterfaces = value;
    });
  }

  final _$updateInterfacesAsyncAction =
      AsyncAction('_ConnectivityStore.updateInterfaces');

  @override
  Future<void> updateInterfaces() {
    return _$updateInterfacesAsyncAction.run(() => super.updateInterfaces());
  }

  @override
  String toString() {
    return '''
connectivityStream: ${connectivityStream},
networkInterfaces: ${networkInterfaces}
    ''';
  }
}
