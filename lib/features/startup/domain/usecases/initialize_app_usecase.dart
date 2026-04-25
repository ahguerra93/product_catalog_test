import '../repositories/startup_repository.dart';

class InitializeAppUseCase {
  final StartupRepository repository;

  InitializeAppUseCase({required this.repository});

  Future<void> call() => repository.initializeData();
}
