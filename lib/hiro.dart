import 'dart:async';

import 'package:flutter/services.dart';

export 'src/annotations.dart';
export 'src/exceptions.dart';

class Hiro {
  static const MethodChannel _channel =
      const MethodChannel('hiro');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
