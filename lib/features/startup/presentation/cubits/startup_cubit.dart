import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/initialize_app_usecase.dart';
import 'startup_state.dart';

class StartupCubit extends Cubit<StartupState> {
  final InitializeAppUseCase initializeAppUseCase;

  StartupCubit({required this.initializeAppUseCase}) : super(StartupInitial());

  Future<void> initialize() async {
    emit(StartupLoading());
    try {
      await initializeAppUseCase();
      emit(StartupReady());
    } catch (e) {
      emit(StartupError(message: e.toString()));
    }
  }
}
