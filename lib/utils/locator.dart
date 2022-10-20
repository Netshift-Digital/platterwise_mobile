import 'package:get_it/get_it.dart';
import 'package:platterwave/data/network/user_services.dart';
import 'package:platterwave/data/network/vblog_services.dart';

GetIt locator = GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => VBlogService());


}