//import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:MuqitTasker/Models/GeneralResponse.dart';
import 'package:MuqitTasker/Models/TaskerSignUpModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class MainScreenC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        home: MainScreenSub());
  }
}

class MainScreenSub extends StatefulWidget {
  @override
  _MainScreenSubState createState() => _MainScreenSubState();
}

class _MainScreenSubState extends State<MainScreenSub> {
  String workDropDownValue = 'Select Your Work';
  String genderDropDownValue = 'Select Gender';
  String firstname;
  bool isRegistrationComplete = false;
  List<String> ismedicalyfit = ['Yes', 'No'];
  int fitindex = 0;
  ProgressDialog progressDialog;
  String taskerid;
  final t_nameController = new TextEditingController();
  final t_emailController = new TextEditingController();
  final t_passwordController = new TextEditingController();
  final t_mobilenoController = new TextEditingController();
  final t_workareaController = new TextEditingController();
  final t_workdescController = new TextEditingController();
  final c_nameController = new TextEditingController();
  final c_emailController = new TextEditingController();
  final c_passwordController = new TextEditingController();
  final c_mobilenoController = new TextEditingController();
  final c_addressController = new TextEditingController();

  File _imageProfile, _imageCNIC, _imageLicense;
  Future<File> getImage() async {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
        message: 'Opening Gallery....',
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
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      progressDialog.hide();
      return File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  Future<GeneralResposne> registerClient(String username, String email,
      String password, String contact, String address, String uri) async {
    http.Response response = await http.post(uri, body: {
      "username": username,
      "email": email,
      "password": password,
      "contact": contact,
      "address": address
    });
    final String responseString = response.body;
    return generalResposneFromJson(responseString);
  }

  Future<TaskerSignUp> registerTasker(
      String name,
      String email,
      String password,
      String contact,
      String address,
      String work,
      String workDetails,
      String gender,
      String uri) async {
    http.Response response = await http.post(uri, body: {
      "name": name,
      "email": email,
      "password": password,
      "contact": contact,
      "address": address,
      "work": work,
      "details": workDetails,
      "gender": gender
    });

    final String responseString = response.body;
    return taskerSignUpFromJson(responseString);
  }

  Future<GeneralResposne> uploadTaskerImages(String profile, String cnic,
      String license, String isfit, String id) async {
    final String url = 'https://muqit.com/app/new_register1.php';
    http.Response response = await http.post(url, body: {
      'id': id,
      'profile': profile,
      'cnicImage': cnic,
      'licenceimage': license,
      'medical_fite': isfit
    });
    return generalResposneFromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text(
              "Registration",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[100],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.green[500],
        body: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: isRegistrationComplete
              ? taskerImageupload()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: t_nameController,
                              onChanged: (data) {
                                setState(() {
                                  firstname = data;
                                });
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
                                  labelText: 'Name',
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
                              controller: t_emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.0),
                                  )),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: t_passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: Colors.green,
                              obscureText: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.0),
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
                                        'Select Your Work',
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
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                      value: genderDropDownValue,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          genderDropDownValue = newValue;
                                          FocusScope.of(context).unfocus();
                                        });
                                      },
                                      items: <String>[
                                        'Select Gender',
                                        'Male',
                                        'Fe-Male',
                                        'She-Male'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                    Icons.wc,
                                    color: Colors.green,
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: t_mobilenoController,
                              cursorColor: Colors.green,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  prefixIcon: Icon(
                                    Icons.local_phone,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Mobile No',
                                  labelStyle: TextStyle(color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.0),
                                  )),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: t_workareaController,
                              cursorColor: Colors.green,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Work Area',
                                  labelStyle: TextStyle(color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.0),
                                  )),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: TextField(
                              controller: t_workdescController,
                              cursorColor: Colors.green,
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  prefixIcon: Icon(
                                    Icons.business_center,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Work Description',
                                  labelStyle: TextStyle(color: Colors.green),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.0),
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
                                "Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                progressDialog = new ProgressDialog(context);
                                progressDialog.style(
                                    message: 'Registering....',
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
                                if (t_nameController.text.isNotEmpty &&
                                    t_emailController.text.isNotEmpty &&
                                    t_passwordController.text.isNotEmpty &&
                                    t_mobilenoController.text.isNotEmpty &&
                                    t_workareaController.text.isNotEmpty &&
                                    t_workdescController.text.isNotEmpty) {
                                  if (t_passwordController.text.length > 6) {
                                    if (RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(t_emailController.text)) {
                                      if (genderDropDownValue !=
                                          'Select Gender') {
                                        if (workDropDownValue !=
                                            'Select Your Work') {
                                          TaskerSignUp taskerResponse =
                                              await registerTasker(
                                                  t_nameController.text.trim(),
                                                  t_emailController.text.trim(),
                                                  t_passwordController.text
                                                      .trim(),
                                                  t_mobilenoController.text
                                                      .trim(),
                                                  t_workareaController.text
                                                      .trim(),
                                                  workDropDownValue,
                                                  t_workdescController.text
                                                      .trim(),
                                                  genderDropDownValue,
                                                  'https://muqit.com/app/tasker_signup.php');

                                          if (taskerResponse.status) {
                                            progressDialog.hide();
                                            taskerid =
                                                taskerResponse.id.toString();
                                            FirebaseFirestore.instance
                                                .collection('Taskers')
                                                .doc(taskerid)
                                                .set({
                                              'location': {
                                                'latitude': 62.25497,
                                                'longitude': -137.07665,
                                              }
                                            });
                                            setState(() {
                                              isRegistrationComplete = true;
                                            });
                                            Toast.show(
                                                'Registered Successfully....',
                                                context,
                                                duration: Toast.LENGTH_LONG,
                                                gravity: Toast.CENTER);
                                          } else {
                                            progressDialog.hide();
                                            Toast.show(
                                                taskerResponse.message, context,
                                                duration: Toast.LENGTH_SHORT,
                                                gravity: Toast.CENTER);
                                          }
                                        } else {
                                          Toast.show(
                                              "Select Your Work....", context,
                                              duration: Toast.LENGTH_SHORT,
                                              gravity: Toast.CENTER);
                                        }
                                      } else {
                                        Toast.show(
                                            "Select Your Gender....", context,
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.CENTER);
                                      }
                                    } else {
                                      Toast.show(
                                          "Email is Invalid......", context,
                                          duration: Toast.LENGTH_SHORT,
                                          gravity: Toast.CENTER);
                                    }
                                  } else {
                                    Toast.show(
                                        "Password Should be 6 Character Long......",
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.CENTER);
                                  }
                                } else {
                                  Toast.show(
                                      "Complete Registration Form.......",
                                      context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.CENTER);
                                }
                              },
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  taskerImageupload() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Text(
                          "Upload CNIC",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.green[50],
                            child: _imageCNIC != null
                                ? Image.file(
                                    _imageCNIC,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                            radius: 30,
                          ),
                        ),
                        Spacer(),
                        MaterialButton(
                          onPressed: () async {
                            File tempimage = await getImage();
                            setState(() {
                              _imageCNIC = tempimage;
                            });
                          },
                          color: Colors.green[400],
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        " Upload Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.green[50],
                            child: _imageProfile != null
                                ? Image.file(
                                    _imageProfile,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                            radius: 30,
                          ),
                        ),
                        Spacer(),
                        MaterialButton(
                          onPressed: () async {
                            File tempimage = await getImage();
                            setState(() {
                              _imageProfile = tempimage;
                            });
                          },
                          color: Colors.green[400],
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        " Upload License",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: _imageLicense != null
                                ? Image.file(
                                    _imageLicense,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.fill,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                            radius: 30,
                          ),
                        ),
                        Spacer(),
                        MaterialButton(
                          onPressed: () async {
                            File tempimage = await getImage();
                            setState(() {
                              _imageLicense = tempimage;
                            });
                          },
                          color: Colors.green[400],
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Text(
                "Are you medically fit?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            FlutterToggleTab(
              height: 30,
              width: 60,
              borderRadius: 20,
              initialIndex: 0,
              selectedBackgroundColors: [Colors.green, Colors.green],
              selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              unSelectedTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              labels: ["Yes", "No"],
              icons: [Icons.done, Icons.clear],
              selectedLabelIndex: (index) {
                fitindex = index;
              },
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              minWidth: 150,
              onPressed: () async {
                progressDialog = new ProgressDialog(context);
                progressDialog.style(
                    message: 'Uplading and Submitting....',
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
                GeneralResposne generalResposne = await uploadTaskerImages(
                    'data:image/jpeg;base64,' +
                        base64Encode(_imageProfile.readAsBytesSync()),
                    'data:image/jpeg;base64,' +
                        base64Encode(_imageCNIC.readAsBytesSync()),
                    'data:image/jpeg;base64,' +
                        base64Encode(_imageLicense.readAsBytesSync()),
                    ismedicalyfit.elementAt(fitindex),
                    taskerid);
                Toast.show(generalResposne.message, context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                progressDialog.hide();
              },
              color: Colors.green[400],
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Submit",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
