import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'globals.dart';
import 'models/contact/contact.dart';
import 'models/contact/userprofile.dart';


/// Called when sending SMS failed
typedef void ContactHandlerFail(Object e);

/// A contact query
class ContactQuery {
  static ContactQuery _instance;
  final MethodChannel _channel;
  static Map<String, Contact> queried = {};
  static Map<String, bool> inProgress = {};

  factory ContactQuery() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(METHOD_CHANNEL_CONTACT_QUERY, const JSONMethodCodec());
      _instance = new ContactQuery._private(methodChannel);
    }
    return _instance;
  }

  ContactQuery._private(this._channel);

  Future<Contact> queryContact(String address) async {
    if (address == null) {
      throw ("address is null");
    }
    if (queried.containsKey(address) && queried[address] != null) {
      return queried[address];
    }
    if (inProgress.containsKey(address) && inProgress[address] == true) {
      throw ("already requested");
    }
    inProgress[address] = true;
    return await _channel.invokeMethod("getContact", {"address": address}).then(
        (dynamic val) async {
      Contact contact = new Contact.fromJson(address, val);
      if (contact.thumbnail != null) {
        await contact.thumbnail.readBytes();
      }
      if (contact.photo != null) {
        await contact.photo.readBytes();
      }
      queried[address] = contact;
      inProgress[address] = false;
      return contact;
    });
  }
}



/// Used to get the user profile
class UserProfileProvider {
  static UserProfileProvider _instance;
  final MethodChannel _channel;

  factory UserProfileProvider() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
          "plugins.babariviere.com/userProfile", const JSONMethodCodec());
      _instance = new UserProfileProvider._private(methodChannel);
    }
    return _instance;
  }

  UserProfileProvider._private(this._channel);

  /// Returns the [UserProfile] data.
  Future<UserProfile> getUserProfile() async {
    return await _channel
        .invokeMethod("getUserProfile")
        .then((dynamic val) async {
      if (val == null)
        return new UserProfile();
      else {
        var userProfile = new UserProfile.fromJson(val);
        if (userProfile.thumbnail != null) {
          await userProfile.thumbnail.readBytes();
        }
        if (userProfile.photo != null) {
          await userProfile.photo.readBytes();
        }
        return userProfile;
      }
    });
  }
}
