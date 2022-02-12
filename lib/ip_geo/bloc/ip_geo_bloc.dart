import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ip_geo_event.dart';
part 'ip_geo_state.dart';

class IpGeoBloc extends Bloc<IpGeoEvent, IpGeoState> {
  IpGeoBloc() : super(IpGeoInitial()) {
    on<IpGeoEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
