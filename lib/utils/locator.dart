import 'package:get_it/get_it.dart';
import 'package:platterwave/data/network/restaurant_service.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/data/network/vblog_services.dart';
import 'package:platterwave/utils/location_service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator
    ..registerLazySingleton(() => UserService())
    ..registerLazySingleton(() => VBlogService())
    ..registerLazySingleton(() => RestaurantService())
    ..registerLazySingleton(() => LocationService());
}
