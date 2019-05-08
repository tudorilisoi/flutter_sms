import 'photo.dart';

class UserProfile {
  String _fullName;
  Photo _photo;
  Photo _thumbnail;
  List<String> _addresses;

  UserProfile() : _addresses = new List<String>();

  UserProfile.fromJson(Map data) {
    if (data.containsKey("name")) {
      this._fullName = data["name"];
    }
    if (data.containsKey("photo")) {
      this._photo = new Photo(Uri.parse(data["photo"]), isFullSize: true);
    }
    if (data.containsKey("thumbnail")) {
      this._thumbnail = new Photo(Uri.parse(data["thumbnail"]));
    }
    if (data.containsKey("addresses")) {
      _addresses = List.from(data["addresses"]);
    }
  }

  /// Gets the full name of the [UserProfile]
  String get fullName => _fullName;

  /// Gets the full size photo of the [UserProfile] if any,
  /// otherwise returns null.
  Photo get photo => _photo;

  /// Gets the thumbnail representation of the [UserProfile] photo if any,
  /// otherwise returns null.
  Photo get thumbnail => _thumbnail;

  /// Gets the collection of phone numbers of the [UserProfile]
  List<String> get addresses => _addresses;
}