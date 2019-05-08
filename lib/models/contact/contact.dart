import 'photo.dart';

class Contact {
  String _fullName;
  String _firstName;
  String _lastName;
  String _address;
  Photo _thumbnail;
  Photo _photo;

  Contact(String address,
      {String firstName,
        String lastName,
        String fullName,
        Photo thumbnail,
        Photo photo}) {
    this._address = address;
    this._firstName = firstName;
    this._lastName = lastName;
    if (fullName == null) {
      this._fullName = _firstName + " " + _lastName;
    } else {
      this._fullName = fullName;
    }
    this._thumbnail = thumbnail;
    this._photo = photo;
  }

  Contact.fromJson(String address, Map data) {
    this._address = address;
    if (data == null) return;
    if (data.containsKey("first")) {
      this._firstName = data["first"];
    }
    if (data.containsKey("last")) {
      this._lastName = data["last"];
    }
    if (data.containsKey("name")) {
      this._fullName = data["name"];
    }
    if (data.containsKey("photo")) {
      this._photo = new Photo(Uri.parse(data["photo"]), isFullSize: true);
    }
    if (data.containsKey("thumbnail")) {
      this._thumbnail = new Photo(Uri.parse(data["thumbnail"]));
    }
  }

  /// Gets the full name of the [Contact]
  String get fullName => this._fullName;

  String get firstName => this._firstName;

  String get lastName => this._lastName;

  /// Gets the address of the [Contact] (the phone number)
  String get address => this._address;

  /// Gets the full size photo of the [Contact] if any, otherwise returns null.
  Photo get photo => this._photo;

  /// Gets the thumbnail representation of the [Contact] photo if any,
  /// otherwise returns null.
  Photo get thumbnail => this._thumbnail;
}
