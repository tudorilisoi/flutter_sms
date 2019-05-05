# This project is maintained

Took over from previous owner because he doesn't maintain it anymore. [github](https://github.com/babariviere/flutter_sms)

## Reason I took over

I am making an sms app (that I will be making open source also when it is more stable) and I needed a good package for all the CRUD actions that I need to do with my messages. 

# Flutter SMS

This is an SMS library for flutter.

It only support Android for now. iOS and MMS is not in the scope of this project.

## Extra

I have forked this repository so I can improve and add my own functionality.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

## Installation and Usage

Once you're familiar with Flutter you may install this package adding `sms` (0.1.4 or higher) to the dependencies list
of the `pubspec.yaml` file as follow:

```yaml
dependencies:
  flutter:
    sdk: flutter

  sms_maintained: ^0.2.5
```

Then run the command `flutter packages get` on the console.

## Querying SMS messages

Add the import statement for `sms` and create an instance of the *SmsQuery* class:

```dart
import 'package:sms/sms.dart';

void main() {
  SmsQuery query = new SmsQuery();
}

```

## Getting all SMS messages

```dart
List<SmsMessage> messages = await query.getAllSms;
``` 

**Note**: _the use of `await` keyword means that `getAllSms` is resolved asynchronously
and a Future is retorned._

## Filtering SMS messages

The method `querySms` from the `SmsQuery` class returns a list of sms depending of the supplied parameters. For example,
for querying all the sms messages sent and received write the followed code:

```dart
await query.querySms({
    kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent]
});
```

You can also query all the sms messages sent and received from a specific contact:

```dart
await query.querySms({
    address: getContactAddress()
});
```

## Getting all Threads Conversations

With `SmsQuery` you can also get the entire list of conversations:

```dart
List<SmsThread> threads = await query.getAllThreads;
```

## Getting the Contact info

Each conversation thread is related with a Contact. 
The class `Contact` contains all the info of a thread contact (address, photo, full name).
To get access to `Contact` class you must import `'package:sms/contact.dart'` into your dart file:

```dart
import 'package:sms/contact.dart';

void main() {
  ...
  Contact contact = threads.first.contact;
  print(contact.address);
}
```

## Querying Contact

You can also query a contact by its address _(phone number)_:

```dart
import 'package:sms/contact.dart';

void main() {
  ContactQuery contacts = new ContactQuery();
  Contact contact = await contacts.queryContact(someAddress());
  print(contact.fullName);
}
String getAddress() {...}
```

## The Contact photo

You can retrieve the photo of the contact (full size or thumbnail):

```dart
...
Uint8List fullSize = contact.photo.bytes;
Uint8List thumbnail = contact.thumbnail.bytes;
```

## User Profile

Some times it is useful to request basic info of the phone owner, like the contact photo, addresses, etc.

```dart
import 'package:sms/contact.dart';

UserProfileProvider provider = new UserProfileProvider();
UserProfile profile = await provider.getUserProfile();
print(profile.fullName);
```

## Sending SMS

What about sending a SMS? All you have to do is to create an instance of the `SmsSender` class:

```dart
import 'package:sms/sms.dart';

void main() {
  SmsSender sender = new SmsSender();
  String address = someAddress();
  ...
  sender.sendSms(new SmsMessage(address, 'Hello flutter!'));
}
```

To be notified when the message is sent and/or delivered, you must add a listener to your message:

```dart
import 'package:sms/sms.dart';

void main() {
  SmsSender sender = new SmsSender();
  String address = someAddress();
  ...
  SmsMessage message = new SmsMessage(address, 'Hello flutter!');
  message.onStateChanged.listen((state) {
    if (state == SmsMessageState.Sent) {
      print("SMS is sent!");
    } else if (state == SmsMessageState.Delivered) {
      print("SMS is delivered!");
    }
  });
  sender.sendSms(message);
}
```
Some times it is useful to be notified of delivered messages regardless of the message. To do that you must subscribe to the `onSmsDelivered` of the `SmsSender` class instance:

```dart
void main() {
...
SmsSender sender = new SmsSender();
sender.onSmsDelivered.listen((SmsMessage message){
  print('${message.address} received your message.');
}));
}
```

You can also send with another SimCard:

```dart
void main() {
SimCardsProvider provider = new SimCardsProvider();
SimCard card = await provider.getSimCards()[0];
SmsSender sender = new SmsSender();
SmsMessage message = new SmsMessage("address", "message");
sender.sendSMS(message, simCard: card);
}
```

**Note**: Using the `onSmsDelivered` from the `SmsSender` will only notify to listeners of messages that has been sent through `SmsSender.send()`.

## Receiving SMS

If you want to be notified for incoming new messages you must subscribe to an instance of the `SmsReceiver` class:

```dart
import 'package:sms/sms.dart';

void main() {
  SmsReceiver receiver = new SmsReceiver();
  receiver.onSmsReceived.listen((SmsMessage msg) => print(msg.body));
}
```

## Deleting SMS

Only deleting one by one is available. Don't forget to make your sms app the default sms app.
[blogpost guide](https://android-developers.googleblog.com/2013/10/getting-your-sms-apps-ready-for-kitkat.html)


```dart
import 'package:sms_maintained/sms.dart';

void main() {
SmsRemover smsRemover = SmsRemover();
bool isRemoved = await smsRemover.removeSmsById(sms.id, _smsThread.threadId);
}
```

## Thread helper

This is meant to make it more easy to use this package. This is meant to manage conversation threads.

### Declaration and initialization
```dart
import 'package:sms_maintained/thread_helper.dart';

void initState() {
 ThreadHelper.getObject().then((value) {
      this.setState(() => this._threadHelper = value);
      this._threadHelper.addObserverToThreads(threadDataListener());
    });
}
```

## Roadmap

- [x] SMS Receiver
- [x] SMS Sender
- [x] SMS Delivery
- [x] SMS Query
- [x] SMS delete
- [x] SMS Thread
- [x] Contact
- [x] Contact Photo (full size, thumbnail)
- [x] User profile (basic info)
- [ ] Improve speed.
- [ ] Add a caching layer.
- [ ] Add a helper.
- [ ] Add observables so you don't need to manually poll for changes.
- [ ] ...

MMS and iOS is not in the scope of this project. If someone wants to add the code and make a merge request for it,
I am happy to include it.

If there are requests you can always make an issue. I will see what I can do.

## Contributors

- babariviere [github](https://github.com/babariviere)
- joanpablo [github](https://github.com/joanpablo)
- saifulfrank [github](https://github.com/saifulfrank)
- geordyvc [github](https://github.com/geordyvcErasmus)

### App logo
Designed and created by [Imrul kayes](https://github.com/saifulfrank)

## Contributions

Any contribution is welcome.

## Donations

I'm a student so money isn't pouring in. Feel free to make a donation.
[PayPal](https://www.paypal.me/GeordyVC)
