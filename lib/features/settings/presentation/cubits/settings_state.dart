import '../../../../shared/domain/enums/simulation_mode.dart';

class SettingsState {
  final SimulationMode simulationMode;

  const SettingsState({this.simulationMode = SimulationMode.success});

  SettingsState copyWith({SimulationMode? simulationMode}) {
    return SettingsState(simulationMode: simulationMode ?? this.simulationMode);
  }
}
