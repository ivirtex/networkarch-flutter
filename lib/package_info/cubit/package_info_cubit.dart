// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'package_info_state.dart';

class PackageInfoCubit extends Cubit<PackageInfoState> {
  PackageInfoCubit() : super(PackageInfoInitial());

  Future<void> fetchPackageInfo() async {
    emit(PackageInfoLoadInProgress());

    final packageInfo = await PackageInfo.fromPlatform();

    emit(PackageInfoLoadSuccess(packageInfo));
  }
}
