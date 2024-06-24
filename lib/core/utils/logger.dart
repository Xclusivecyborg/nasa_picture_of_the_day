import 'dart:developer';

import 'package:flutter/foundation.dart';


/// A simple logger function that logs data only in debug mode
void debugLog(dynamic data) {
  if (kDebugMode) {
    log('💡💡[LOG]💡💡 $data');
  }
}
