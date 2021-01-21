import 'package:MuqitTasker/Models/GeneralResponse.dart';
import 'package:MuqitTasker/Models/TAppointmentListModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../Utils/Map.dart';

class TAppointmentList extends StatefulWidget {
  final String id, taskername;
  TAppointmentList(this.id, this.taskername, {Key key}) : super(key: key);
  @override
  T_AppoinStatetmentList createState() => T_AppoinStatetmentList();
}

class T_AppoinStatetmentList extends State<TAppointmentList> {
  bool isloading = true;
  List<TAppointmentListM> appointmentlist = new List<TAppointmentListM>();
  final quotetextEditingController = TextEditingController();

  Future<void> getAppointmentList(String id) async {
    final String uri = 'https://muqit.com/app/allappointments.php';
    http.Response response = await http.post(uri, body: {'to_id': id});
    if (response.body.toString().trim() != 'null') {
      setState(() {
        appointmentlist = tAppointmentListMFromJson(response.body);
      });
    }
  }

  loadData(String id) async {
    await getAppointmentList(id);
    setState(() {
      isloading = false;
    });
  }

  Future<GeneralResposne> submitQuote(
      String id, String value, String url) async {
    http.Response response =
        await http.post(url, body: {'ids': id, 'initial': value});
    return generalResposneFromJson(response.body);
  }

  ProgressDialog progressDialog;
  showProgressDialog(String text) async {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
        message: text,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600));
    await progressDialog.show();
  }

  void showDialog(String quoteType, String id) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 300,
            child: Column(
              children: [
                SizedBox(height: 10),
                Material(
                  child: Text(
                    quoteType,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    child: TextField(
                      controller: quotetextEditingController,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        labelText: "Enter " + quoteType + " Value",
                        labelStyle: TextStyle(color: Colors.green),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          //borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                          // borderRadius: BorderRadius.circular(10.0)
                        ),
                        prefixIcon: Icon(
                          Icons.payment_rounded,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  minWidth: 150,
                  color: Colors.green,
                  splashColor: Colors.lightGreen,
                  onPressed: () async {
                    if (quotetextEditingController.text.isNotEmpty) {
                      ProgressDialog progressDialog =
                          new ProgressDialog(context);
                      progressDialog.style(
                          message: 'Submitting....',
                          borderRadius: 10.0,
                          backgroundColor: Colors.white,
                          progressWidget: CircularProgressIndicator(),
                          elevation: 10.0,
                          insetAnimCurve: Curves.easeInOut,
                          progress: 0.0,
                          maxProgress: 100.0,
                          progressTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w400),
                          messageTextStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600));
                      await progressDialog.show();
                      Navigator.pop(context);
                      if (quoteType == 'Initial Quote') {
                        final String uri = 'https://muqit.com/app/iniQuote.php';
                        GeneralResposne generalResposne = await submitQuote(
                            id, quotetextEditingController.text, uri);
                        Toast.show(generalResposne.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      } else if (quoteType == 'Final Quote') {
                        final String uri =
                            'https://muqit.com/app/finalQuote.php';
                        GeneralResposne generalResposne = await submitQuote(
                            id, quotetextEditingController.text, uri);
                        Toast.show(generalResposne.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      }
                      Navigator.pop(context);
                      progressDialog.hide();
                      await getAppointmentList(widget.id);
                    } else {
                      Toast.show('Enter Quote Value....', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    }
                  },
                )
              ],
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    loadData(widget.id);
  }

  Future<GeneralResposne> acceptAppointment(String id) async {
    String uri = 'https://muqit.com/app/approve.php';
    http.Response response = await http.post(uri, body: {'approve_id': id});
    return generalResposneFromJson(response.body);
  }

  Future<GeneralResposne> rejectAppointment(String id) async {
    String uri = 'https://muqit.com/app/Reject.php';
    http.Response response = await http.post(uri, body: {'id': id});
    return generalResposneFromJson(response.body);
  }

  Future<GeneralResposne> sendEmail(
      String cName, String tName, String url) async {
    http.Response response =
        await http.post(url, body: {'name': cName, 'tname': tName});
    return generalResposneFromJson(response.body);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await loadData(widget.id);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await loadData(widget.id);
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : appointmentlist.length == 0
              ? Center(child: Text("No Appointments"))
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
                      itemCount: appointmentlist.length,
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: CircleAvatar(
                                            child: Icon(Icons.person,
                                                color: Colors.white, size: 30),
                                            radius: 34,
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
                                                    Icons.format_list_numbered,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
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
                                                    Icons.account_circle,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .username,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Phone #",
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
                                                    Icons.phone,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .contact,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Work Duration",
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
                                                    Icons.work,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .workType,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 10,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
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
                                                        .calendar_today_outlined,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .fixDate,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Description",
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
                                                    Icons.description_outlined,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .description,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Address",
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
                                                    Icons.pin_drop_outlined,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .workAddress,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Status",
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
                                                        .priority_high_outlined,
                                                    color: Colors.black,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .status,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Job Rate",
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
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .jobRateOffered,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Company Profit",
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
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .muqitProfit,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Tasker Profit",
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
                                                      appointmentlist
                                                          .elementAt(index)
                                                          .taskerProfit,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "Initial Quote",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.green[700]),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 140,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.payment_sharp,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          appointmentlist
                                                              .elementAt(index)
                                                              .initialQuote,
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
                                                FlatButton(
                                                    color: Colors.green[100],
                                                    onPressed: () {
                                                      showDialog(
                                                          'Initial Quote',
                                                          appointmentlist
                                                              .elementAt(index)
                                                              .id);
                                                    },
                                                    child: Text(
                                                      "Enter Value",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Text(
                                              "Final Quote",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.green[700]),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 140,
                                                  height: 30,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.payment_rounded,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          appointmentlist
                                                              .elementAt(index)
                                                              .finalQuote,
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
                                                FlatButton(
                                                    color: Colors.green[100],
                                                    onPressed: () {
                                                      showDialog(
                                                          'Final Quote',
                                                          appointmentlist
                                                              .elementAt(index)
                                                              .id);
                                                    },
                                                    child: Text(
                                                      "Enter Value",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.green,
                                      splashColor: Colors.lightGreen,
                                      onPressed: () async {
                                        showProgressDialog('Accepting....');
                                        GeneralResposne generalResposne =
                                            await acceptAppointment(
                                                appointmentlist
                                                    .elementAt(index)
                                                    .id);
                                        progressDialog.hide();
                                        Toast.show(
                                            generalResposne.message, context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.CENTER);
                                        loadData(widget.id);
                                      }),
                                  MaterialButton(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.red,
                                      splashColor: Colors.redAccent,
                                      onPressed: () async {
                                        showProgressDialog('Rejecting....');
                                        GeneralResposne generalResposne =
                                            await rejectAppointment(
                                                appointmentlist
                                                    .elementAt(index)
                                                    .id);
                                        progressDialog.hide();
                                        Toast.show(
                                            generalResposne.message, context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.CENTER);
                                        loadData(widget.id);
                                      }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MaterialButton(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.green,
                                      splashColor: Colors.lightGreen,
                                      onPressed: () async {
                                        showProgressDialog(
                                            'Sending Mail.......');
                                        GeneralResposne generalResponse =
                                            await sendEmail(
                                                appointmentlist
                                                    .elementAt(index)
                                                    .username,
                                                widget.taskername,
                                                'https://muqit.com/app/SignIntasker.php');
                                        progressDialog.hide();
                                        Toast.show(
                                            generalResponse.message, context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.CENTER);
                                      }),
                                  MaterialButton(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          "Sign Out",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.green,
                                      splashColor: Colors.lightGreen,
                                      onPressed: () async {
                                        showProgressDialog(
                                            'Sending Mail.......');
                                        GeneralResposne generalResponse =
                                            await sendEmail(
                                                appointmentlist
                                                    .elementAt(index)
                                                    .username,
                                                widget.taskername,
                                                'https://muqit.com/app/taskersignout.php');
                                        progressDialog.hide();
                                        Toast.show(
                                            generalResponse.message, context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.CENTER);
                                      }),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),
    );
  }
}
