import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/data/datasources/product_hive_datasource.dart';
import '../../../../shared/domain/enums/simulation_mode.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final ProductHiveDataSource _hiveDataSource;

  SettingsCubit({required ProductHiveDataSource hiveDataSource})
    : _hiveDataSource = hiveDataSource,
      super(const SettingsState());

  void setSimulationMode(SimulationMode mode) {
    _hiveDataSource.simulationMode = mode;
    emit(state.copyWith(simulationMode: mode));
  }
}
