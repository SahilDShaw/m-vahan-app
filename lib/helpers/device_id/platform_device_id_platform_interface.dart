import 'dart:async';

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const MethodChannel _channel = MethodChannel('com.aniworks.flutter/lottery_app');

class MethodChannelPlatformDeviceId extends PlatformDeviceIdPlatform {
  @override
  Future<String?> getDeviceId() {
    return _channel.invokeMethod<String?>('getDeviceId');
  }
}

abstract class PlatformDeviceIdPlatform extends PlatformInterface {
  /// Constructs a UrlLauncherPlatform.
  PlatformDeviceIdPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformDeviceIdPlatform _instance = MethodChannelPlatformDeviceId();

  /// The default instance of [PlatformDeviceIdPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformDeviceId].
  static PlatformDeviceIdPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MethodChannelPlatformDeviceId] when they register themselves.
  static set instance(PlatformDeviceIdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Get the platform device id - [String]
  Future<String?> getDeviceId() {
    throw UnimplementedError('getDeviceId() has not been implemented.');
  }
}
