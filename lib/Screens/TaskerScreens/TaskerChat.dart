import 'package:MuqitTasker/Models/TaskerChatModel.dart';
import 'package:MuqitTasker/Screens/TaskerScreens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskerChatHistory extends StatefulWidget {
  final String taskerId, name;
  TaskerChatHistory(this.taskerId, this.name, {Key key}) : super(key: key);
  @override
  _TaskerChatHistoryState createState() => _TaskerChatHistoryState();
}

class _TaskerChatHistoryState extends State<TaskerChatHistory> {
  bool isLoading = true;
  List<TaskerChat> taskerChatList = new List<TaskerChat>();

  Future<void> getChats(String tid) async {
    final String uri = 'https://muqit.com/app/Contact-Client.php';
    http.Response response = await http.post(uri, body: {'to_user_id': tid});
    if (response.body.trim() != 'null')
      taskerChatList = taskerChatFromJson(response.body);
  }

  _loadData(String tid) async {
    await getChats(tid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadData(widget.taskerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        body: Card(
          // elevation: 20,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: taskerChatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    //itemCount: dummyData.length;
                    SizedBox(
                      height: 16,
                    );
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 30),
                                  radius: 34,
                                  backgroundColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          taskerChatList
                                              .elementAt(index)
                                              .username,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(children: [
                                      Text(
                                        taskerChatList.elementAt(index).email,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ])
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(243, 245, 248, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    MaterialButton(
                                        elevation: 10,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            "Chat",
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          taskerChatList
                                                              .elementAt(index)
                                                              .id,
                                                          widget.taskerId,
                                                          'TaskertoClient',
                                                          widget.name)));
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
        ));
  }
}
