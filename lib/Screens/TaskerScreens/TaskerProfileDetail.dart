import 'package:flutter/material.dart';


class TaskerProfileDetail extends StatefulWidget {
  @override
  _TaskerProfileDetailState createState() => _TaskerProfileDetailState();
}

class _TaskerProfileDetailState extends State<TaskerProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: BackButton(color: Colors.black,),elevation: 0,backgroundColor: Colors.white,title: Text("Tasker Profile",style: TextStyle(fontSize: 22,color: Colors.black),),),
      backgroundColor: Colors.green,
        body:Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child:Image.asset("asset/images/user icon 2.jpg",fit: BoxFit.contain,)
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text("Noman Arshad",style: TextStyle(fontSize:25,fontWeight: FontWeight.w500,color: Colors.white),)
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category),
                            Text("Categories",style: TextStyle(fontSize:15,fontWeight: FontWeight.w500,color: Colors.white),),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_pin),
                            Text("Location",style: TextStyle(fontSize:15,fontWeight: FontWeight.w500,color: Colors.white),),
                          ],
                        )
                      ],
                    )
                  ],
                )
            ),
            SizedBox(height: 15,),
            Expanded(
              // flex: 2,
              // top: 270,right: 0,left: 0,bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20,top: 10,right: 20,bottom: 10),
                          child:  Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.handyman,color: Colors.green,),
                                          SizedBox(width: 5,),
                                          Text("Task Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Icon(Icons.category,color: Colors.green,),
                                          SizedBox(width: 5,),
                                          Text("Category",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),

                                    ],
                                  )),
                              Row(
                                children: [
                                  Icon(Icons.info,color: Colors.green,),
                                  SizedBox(width: 5,),
                                  Text("Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                ],
                              )
                            ],
                          ),

                        ),
                        Divider(height: 1,thickness: 1,color: Colors.greenAccent,indent:20,endIndent: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child:  Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.handyman,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Task Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Icon(Icons.category,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Category",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                    ],
                                  )),
                              Row(
                                children: [
                                  Icon(Icons.info,color: Colors.green,),
                                  SizedBox(width: 5,),
                                  Text("Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                ],
                              )
                            ],
                          ),

                        ),
                        Divider(height: 1,thickness: 1,color: Colors.greenAccent,indent:20,endIndent: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child:  Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.handyman,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Task Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Icon(Icons.category,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Category",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                    ],
                                  )),
                              Row(
                                children: [
                                  Icon(Icons.info,color: Colors.green,),
                                  SizedBox(width: 5,),
                                  Text("Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                ],
                              )
                            ],
                          ),

                        ),
                        Divider(height: 1,thickness: 1,color: Colors.greenAccent,indent:20,endIndent: 20,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child:  Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.handyman,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Task Name",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          Icon(Icons.category,color: Colors.green),
                                          SizedBox(width: 5,),
                                          Text("Category",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                        ],
                                      ),
                                    ],
                                  )),
                              Row(
                                children: [
                                  Icon(Icons.info,color: Colors.green,),
                                  SizedBox(width: 5,),
                                  Text("Status",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
                                ],
                              )
                            ],
                          ),

                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
      );
    
  }
}
