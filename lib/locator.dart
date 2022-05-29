import 'package:fchatty/data/abstract/i_auth_service.dart';
import 'package:fchatty/data/abstract/i_data_service.dart';
import 'package:fchatty/data/concreate/firebase_auth_service.dart';
import 'package:fchatty/data/concreate/firestore_data_service.dart';
import 'package:fchatty/service/notification_send_service.dart';
import 'package:fchatty/repository/user_repository.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton<IAuthService>(() => FakeAuthService());
  locator.registerLazySingleton<IAuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<IDataService>(() => FirestoreDataService());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<NotificationSendService>(() => NotificationSendService());
}
