// ignore_for_file: camel_case_types

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

// Load our C lib
final DynamicLibrary nativeLib = Platform.isAndroid ? DynamicLibrary.open("libapi_util.so") : DynamicLibrary.process();

// C Functions signatures
typedef _c_getFernetKey = Pointer<Utf8> Function();
typedef _c_getCertificatePassword = Pointer<Utf8> Function();

// Dart functions signatures
typedef _dart_getFernetKey = Pointer<Utf8> Function();
typedef _dart_getCertificatePassword = Pointer<Utf8> Function();

// Create dart functions that invoke the C function
final _getFernetKey = nativeLib.lookupFunction<_c_getFernetKey, _dart_getFernetKey>('get_fernet_key');
final _getCertificatePassword =
    nativeLib.lookupFunction<_c_getCertificatePassword, _dart_getCertificatePassword>('get_certificate_password');

class SecureStringApi {
  static String getFernetKey() {
    Pointer<Utf8> strPtr = _getFernetKey();
    String str = strPtr.toDartString();

    return str;
  }

  static String getCertificatePassword() {
    Pointer<Utf8> strPtr = _getCertificatePassword();
    String str = strPtr.toDartString();

    return str;
  }
}
