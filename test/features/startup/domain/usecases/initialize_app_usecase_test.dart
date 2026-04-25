import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product_catalog_test/features/startup/domain/usecases/initialize_app_usecase.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late InitializeAppUseCase useCase;
  late MockStartupRepository mockRepository;

  setUp(() {
    mockRepository = MockStartupRepository();
    useCase = InitializeAppUseCase(repository: mockRepository);
  });

  group('InitializeAppUseCase', () {
    test('calls repository.initializeData', () async {
      when(mockRepository.initializeData()).thenAnswer((_) async {});

      await useCase();

      verify(mockRepository.initializeData()).called(1);
    });

    test('propagates exception from repository', () async {
      when(mockRepository.initializeData()).thenThrow(Exception('Init failed'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
