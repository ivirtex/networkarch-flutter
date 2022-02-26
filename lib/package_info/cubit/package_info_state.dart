part of 'package_info_cubit.dart';

abstract class PackageInfoState extends Equatable {
  const PackageInfoState();

  @override
  List<Object> get props => [];
}

class PackageInfoInitial extends PackageInfoState {}

class PackageInfoLoadInProgress extends PackageInfoState {}

class PackageInfoLoadSuccess extends PackageInfoState {
  const PackageInfoLoadSuccess(this.packageInfo);

  final PackageInfo packageInfo;
}
