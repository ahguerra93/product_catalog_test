abstract class StartupState {}

class StartupInitial extends StartupState {}

class StartupLoading extends StartupState {}

class StartupReady extends StartupState {}

class StartupError extends StartupState {
  final String message;
  StartupError({required this.message});
}
