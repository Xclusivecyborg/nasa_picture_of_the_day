import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

/// This is our global ServiceLocator
/// Dependencies registered here can be accessed from anywhere in the app
/// To access them, use the [getIt] instance like so: getIt<YOUR_SERVICE>()
final getIt = GetIt.instance;

@injectableInit
GetIt configureDependencies() => getIt.init();
