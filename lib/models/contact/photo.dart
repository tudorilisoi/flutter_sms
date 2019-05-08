import 'dart:typed_data';
import 'package:sms_maintained/globals.dart';
import 'package:flutter/services.dart';

class Photo {
  final Uri _uri;
  final bool _isFullSize;
  Uint8List _bytes;

  /// Gets the bytes of the photo.
  Uint8List get bytes => _bytes;

  Photo(this._uri, {bool isFullSize = false}) : _isFullSize = isFullSize;

  /// Read async the bytes of the photo.
  Future<Uint8List> readBytes() async {
    if (this._uri != null && this._bytes == null) {
      var photoQuery = new ContactPhotoQuery();
      this._bytes =
      await photoQuery.queryContactPhoto(this._uri, fullSize: _isFullSize);
    }
    return _bytes;
  }


}

/// A contact's photo query
class ContactPhotoQuery {
  static ContactPhotoQuery _instance;
  final MethodChannel _channel;

  factory ContactPhotoQuery() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
          METHOD_CHANNEL_CONTACT_PHOTO_QUERY,
          const StandardMethodCodec());
      _instance = new ContactPhotoQuery._private(methodChannel);
    }
    return _instance;
  }

  ContactPhotoQuery._private(this._channel);

  /// Get the bytes of the photo specified by [uri].
  /// To get the full size of contact's photo the optional
  /// parameter [fullSize] must be set to true. By default
  /// the returned photo is the thumbnail representation of
  /// the contact's photo.
  Future<Uint8List> queryContactPhoto(Uri uri, {bool fullSize = false}) async {
    return await _channel.invokeMethod(
        "getContactPhoto", {"photoUri": uri.path, "fullSize": fullSize});
  }
}