import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:MuqitTasker/Models/TAppointmentListModel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_geolocation_plugin/location_item.dart';
import 'package:background_location/background_location.dart';
import 'package:MuqitTasker/ContactUs.dart';
import 'package:MuqitTasker/Screens/LoginScreen.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/TAppointmentList.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/TSetting.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/TaskerChat.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/TaskerHistory.dart';
import 'package:MuqitTasker/Utils/TaskerDrawerBody.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:http/http.dart' as http;
import 'package:background_geolocation_plugin/background_geolocation_plugin.dart';

class MainTaskerScreenSub extends StatefulWidget {
  final String email;
  final String username;
  final String id;
  MainTaskerScreenSub(this.email, this.username, this.id, {Key key})
      : super(key: key);

  @override
  __MainTaskerScreenState createState() => __MainTaskerScreenState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
showNotification(String title, String body) async {
  var android = AndroidNotificationDetails('10', 'channel ', 'description',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: iOS);
  await flutterLocalNotificationsPlugin.show(0, title, body, platform,
      payload: 'Welcome to the Local Notification demo');
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // if (message['data']['tid'] == preferences.getString("id")) {
  showNotification(message['data']['title'], message['data']['body']);
  //}

  // Or do other work.
}

class __MainTaskerScreenState extends State<MainTaskerScreenSub> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  var title = "Task History";

  List<TAppointmentListM> appointmentlist = new List<TAppointmentListM>();

  Future<void> getAppointmentList() async {
    final String uri = 'https://muqit.com/app/allappointments.php';
    http.Response response = await http.post(uri, body: {'to_id': widget.id});

    appointmentlist = tAppointmentListMFromJson(response.body);
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    BackgroundLocation.stopLocationService();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  Timer timer;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Timer timer1;

  var res;
  List<LocationItem> allLocations = [];

  addTaskerdata(Location location) async {
    String token = await _firebaseMessaging.getToken();
    firestore.collection('Taskers').doc(widget.id).set({
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      },
      'device_token': token
    });
  }

  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: null);
    //addToken();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //if (message['data']['id'] == widget.id) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'big_picture',
                title: message['data']['title'],
                body: message['data']['body']));
        //}
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  if (message['data']['id'] == widget.id) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'big_picture',
                title: message['data']['title'],
                body: message['data']['body']));
        //}
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // if (message['data']['id'] == widget.id) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'big_picture',
                title: message['data']['title'],
                body: message['data']['body']));
        //}
        //_navigateToItemDetail(message);
      },
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // AwesomeNotifications().actionStream.listen((receivedNotification) {});

    /* FirebaseFirestore.instance
        .collection("Users")
        .add({"email": 'aba@abc.com', "password": '1245'});*/
    //showData();
    BackgroundLocation.startLocationService();
    BackgroundLocation.getPermissions(
      onGranted: () {
        GeoFirePoint geoPoint =
            geo.point(latitude: 34.6453, longitude: 74.2344);

        BackgroundLocation.getLocationUpdates((location) {
          addTaskerdata(location);
        });
      },
      onDenied: () {
        print('Access Denied');
      },
    );
  }

  getLoglat() async {
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      showData();
    });
  }

  showData() async {
    res = await BackgroundGeolocationPlugin.startLocationTracking();
    print('Plugin Result :' + res);
  }

  checkforNewAppointment() async {
    int helloAlarmID = 1;
    await AndroidAlarmManager.periodic(
        const Duration(seconds: 1), helloAlarmID, showNotification);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => MinimizeApp.minimizeApp(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SliderMenuContainer(
              appBarColor: Colors.white,
              key: _key,
              slideDirection: SlideDirection.LEFT_TO_RIGHT,
              appBarPadding: const EdgeInsets.only(top: 10),
              sliderMenuOpenSize: 210,
              appBarHeight: 60,
              trailing: IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  logOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
              title: Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              sliderMenu: TaskerMenuWidget(
                email: widget.email,
                name: widget.username,
                onItemClick: (title) {
                  _key.currentState.closeDrawer();
                  setState(() {
                    this.title = title;
                  });
                },
              ),
              sliderMain: Views(title, _key, context)),
        ),
      ),
    );
  }

  Widget Views(var _title, GlobalKey<SliderMenuContainerState> _key,
      BuildContext context) {
    switch (_title) {
      case "Task History":
        {
          /*AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'big_picture',
                  title: 'Simple Notification',
                  body: 'Simple body'));*/
          return TaskerHistory(widget.id, widget.username);
        }
      case "All Appointments":
        {
          return TAppointmentList(widget.id, widget.username);
        }
      case "Chats":
        {
          return TaskerChatHistory(widget.id, widget.username);
        }
      case "Settings":
        {
          return TSetting(widget.id, widget.username, widget.email);
        }
      case "Contact Us":
        {
          return ContactUs();
        }
    }
  }
}
