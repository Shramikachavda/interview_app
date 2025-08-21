import 'package:get_it/get_it.dart';
import 'data/repository/interview_repo.dart';   // InterviewRepoImpl
import 'domain/repo/interview_repo.dart';
import 'netwrok/app_client.dart';      // IInterviewRepository

final getIt = GetIt.instance;



Future<void> setupLocator() async {
  // ApiClient singleton via GetIt
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repo depends on ApiClient
  getIt.registerLazySingleton<IInterviewRepository>(
        () => InterviewRepoImpl(getIt<ApiClient>()),
  );print(getIt.isRegistered<IInterviewRepository>()); // should print true
  print(getIt.isRegistered<ApiClient>());            // should print true

}
