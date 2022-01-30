import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ping_state.dart';

class PingCubit extends Cubit<PingState> {
  PingCubit() : super(PingInitial());
}
