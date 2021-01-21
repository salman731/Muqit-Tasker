import 'package:MuqitTasker/Models/GeneralResponse.dart';
import 'package:MuqitTasker/Utils/CustomDatePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class AddTask extends StatefulWidget {
  final String id, username;
  AddTask(this.id, this.username, {Key key}) : super(key: key);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  Duration duration = Duration(hours: 0, minutes: 0);
  String workDropDownValue = 'Nature of Job';
  final workinghour = TextEditingController();
  final perhourrate = new TextEditingController();
  final totalpayment = new TextEditingController();
  final employeepayment = new TextEditingController();
  final totime = new TextEditingController();
  final fromtime = new TextEditingController();
  bool isloading = true;

  Future<GeneralResposne> addTask(
      String id,
      String name,
      String date,
      String workingHour,
      String perhourRate,
      String totalPayment,
      String employeePayment,
      String toTime,
      String fromTime,
      String jobNature) async {
    final String uri = 'https://muqit.com/app/Insertnew_task.php';
    http.Response response = await http.post(uri, body: {
      'worker_id': id,
      'name': name,
      'date': date,
      'timearrival': '',
      'strtime': fromTime,
      'endtime': toTime,
      'hourwork': workingHour,
      'perhourrate': perhourRate,
      'natureofjob': jobNature,
      'totalpayment': totalPayment,
      'employeepayment': employeePayment
    });
    return generalResposneFromJson(response.body);
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "New Task",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.green[50],
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: widget.id),
                    onChanged: (data) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.format_list_numbered,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Worker ID',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: widget.username),
                    onChanged: (data) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(
                        text: DateFormat('yMd').format(DateTime.now())),
                    onChanged: (data) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.name,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                            width: 2.0,
                          ),
                        )),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: fromtime,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(
                            Icons.date_range_outlined,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'From Time',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          )),
                      onTap: () {
                        DatePicker.showTimePicker(context, onConfirm: (time) {
                          var tempdate = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .parse(time.toString());
                          fromtime.text = DateFormat.jm().format(tempdate);
                        });
                      },
                      readOnly: true,
                    )),
                Container(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      controller: totime,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(
                            Icons.date_range_outlined,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'To Time',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          )),
                      onTap: () {
                        DatePicker.showTimePicker(context, onConfirm: (time) {
                          var tempdate = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .parse(time.toString());
                          totime.text = DateFormat.jm().format(tempdate);
                        });
                      },
                      readOnly: true,
                    )),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: workinghour,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.timer,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Working Hour',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: '10'),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.money,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Per Hour Rate',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey)),
                        padding: EdgeInsets.only(left: 46),
                        margin: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: workDropDownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                workDropDownValue = newValue;
                                FocusScope.of(context).unfocus();
                              });
                            },
                            items: <String>[
                              'Nature of Job',
                              'Beautician',
                              'CCTV & Fire Alarm Installers',
                              'Laptop-Repair',
                              'Mobile-Phone-Repair',
                              'Carpenter',
                              'Electrician',
                              'Mechanic',
                              'Welder',
                              'Gardener',
                              'Handyman',
                              'Painter',
                              'Plumber',
                              'Driving-Instructor',
                              'Pick-n-Drop',
                              'Delivery-Drivers',
                              'Home-Cleaning',
                              'Commercial-Cleaning',
                              'Car-Wash',
                              'Blacksmith',
                              'Spray-Man',
                              'Tutor',
                              'Tailor',
                              'Grocery-Man',
                              'Event-Managment',
                              'Visa-Service',
                              'Door-to-Door-Advertising',
                              'Lab-Service',
                              'Nurse',
                              'Glass-Tasker"',
                              'Utility-Tasker',
                              'Pet-Service',
                              'Fitness-Trainer',
                              'Grocery-Man',
                              'Mistry/Mazdoor',
                              'Overall-Hiring',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 20),
                        child: Icon(
                          Icons.business,
                          color: Colors.green,
                        )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: ''),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.payment,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Total Payment',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: ''),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        prefixIcon: Icon(
                          Icons.payments_outlined,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Employee Payment',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.green, width: 2.0),
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: MaterialButton(
                    padding: EdgeInsets.all(10),
                    elevation: 8,
                    minWidth: 250,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    onPressed: () async {
                      if (totime.text.isNotEmpty &&
                          fromtime.text.isNotEmpty &&
                          workinghour.text.isNotEmpty &&
                          workDropDownValue != 'Nature of Job') {
                        ProgressDialog progressDialog =
                            new ProgressDialog(context);
                        progressDialog.style(
                            message: 'Adding....',
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
                        GeneralResposne generalResponse = await addTask(
                            widget.id,
                            widget.username,
                            DateFormat('dd-MM-yyyy')
                                .format(DateTime.now())
                                .toString(),
                            workinghour.text.trim(),
                            '10',
                            '',
                            '',
                            totime.text.trim(),
                            fromtime.text.trim(),
                            workDropDownValue);
                        Toast.show(generalResponse.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                        progressDialog.hide();
                      } else {
                        Toast.show(
                            'Enter To From Date, Work Hour and Job Nature....',
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.CENTER);
                      }
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    Duration duration = Duration(hours: 0, minutes: 0);
  }
}
