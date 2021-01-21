import 'dart:async';
import 'dart:convert';

import 'package:MuqitTasker/Models/TaskerHistory.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/AddTask.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskerHistory extends StatefulWidget {
  final String id, username;
  TaskerHistory(this.id, this.username, {Key key}) : super(key: key);
  @override
  _taskerHistoryState createState() => _taskerHistoryState();
}

class _taskerHistoryState extends State<TaskerHistory> {
  List<TaskerHistoryModel> taskerHistoryList = new List<TaskerHistoryModel>();
  bool isloading = true;
  Future<void> getTaskerHistoryData(String id) async {
    final String url = 'https://muqit.com/app/tasker_profile.php';
    http.Response response = await http.post(url, body: {'worker_id': id});
    if (response.body.toString().trim() != 'null') {
      taskerHistoryList = taskerHistoryModelFromJson(response.body);
    }
  }

  loadData(String id) async {
    await getTaskerHistoryData(id);
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    loadData(widget.id);
    /* firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // completer.complete(message);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'big_picture',
                title: message['notification']['title'],
                body: message['notification']['body']));
      },
      onLaunch: (Map<String, dynamic> message) async {
        // completer.complete(message);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'big_picture',
                title: message['notification']['title'],
                body: message['notification']['body']));
      },
    );*/
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    await loadData(widget.id);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Tasker Screen pop op');
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              //   await sendAndRetrieveMessage();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddTask(widget.id, widget.username)));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          backgroundColor: Colors.green[50],
          body: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : taskerHistoryList.length == 0
                  ? Center(child: Text("No Task History"))
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: ListView.builder(
                          itemCount: taskerHistoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            //itemCount: dummyData.length;

                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[400],
                                      offset: Offset(3, 3),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0)
                                ],
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: CircleAvatar(
                                                child: Icon(Icons.work_outline,
                                                    color: Colors.white,
                                                    size: 30),
                                                radius: 30,
                                                backgroundColor: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sr #",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .format_list_numbered,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .workerId,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Name",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.perm_identity,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .name,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .date
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 10,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Time Arrival",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .time_to_leave_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .timearrival,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Time Period",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.av_timer_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                                  .elementAt(
                                                                      index)
                                                                  .strtime +
                                                              ' To ' +
                                                              taskerHistoryList
                                                                  .elementAt(
                                                                      index)
                                                                  .endtime,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Work Hour",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.timer_rounded,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .hourwork,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Per Hour Rate",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.money,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .perhourrate,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Job Nature",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.work_outline,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .natureofjob,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Total Payment",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.payment,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .totalpayment,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Employee Payment",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[700]),
                                                ),
                                                Container(
                                                  width: 250,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.payments_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          taskerHistoryList
                                                              .elementAt(index)
                                                              .employeepayment,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    )),
    );
  }
}
