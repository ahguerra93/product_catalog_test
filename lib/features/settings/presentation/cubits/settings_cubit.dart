import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/domain/enums/simulation_mode.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setSimulationMode(SimulationMode mode) {
    emit(state.copyWith(simulationMode: mode));
  }
}
