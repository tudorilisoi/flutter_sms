import 'package:sms_maintained/sms.dart';
import 'package:sms_maintained/contact.dart';
import 'dart:collection';
import 'package:observable/observable.dart';


/*
* this class is meant to make it more easy to interact with the other classes
* you don't have to use this to make use of contact.dart and sms.dart
* */
class ThreadHelper {
  ObservableList<SmsThread> threads;
  static ThreadHelper _threadHelper;

  List<Function> functionsToNotifyIfThreadChanges;

  ThreadHelper();

  static Future<ThreadHelper> getObject() async {
    if(_threadHelper == null){
      _threadHelper = ThreadHelper();
      await _threadHelper.loadEverything();
      return _threadHelper;
    }
    else {
      return _threadHelper;
    }
  }



  /*
  * Do not forget to have the right permissions or else this is going to fail big time.
  * */
  Future loadEverything() async{
    SmsQuery query = new SmsQuery();
    List<SmsThread> allThreadsNormalList = await query.getAllThreads;
    threads = ObservableList();
    for(SmsThread smsThread in allThreadsNormalList) {
      this.threads.add(smsThread);
    }
    _threadHelper.threads.changes.listen((data) {
      for (Function f in _threadHelper.functionsToNotifyIfThreadChanges){
        try {

          f();

      } catch (e){
        print("Function does not exists:\n" + e);
      }
      }
    });
  }


  Future refreshThreads() async {
    SmsQuery query = new SmsQuery();
    List<SmsThread> allThreadsNormalList = await query.getAllThreads;
    threads.clear();
    for(SmsThread smsThread in allThreadsNormalList) {
      this.threads.add(smsThread);
    }
  }

  /*
  * TODO : load only a certain thread with an id
  * */
  Future refreshThreadWithId() async {
    throw new Exception("not yet implemented");
  }


  //Give a function that needs to be activated when the data changes
  addObserverToThreads(Function f) {
    this.functionsToNotifyIfThreadChanges.add(f);
  }



}