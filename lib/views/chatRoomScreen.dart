import 'package:flutter/material.dart';
import 'package:sharechat/helper/authenticate.dart';
import 'package:sharechat/helper/constants.dart';
import 'package:sharechat/helper/helperfunctions.dart';
import 'package:sharechat/services/auth.dart';
import 'package:sharechat/services/database.dart';
import 'package:sharechat/views/conversationScreen.dart';
import 'package:sharechat/views/search.dart';
import 'package:sharechat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return ChatRoomsTile(
                username: snapshot.data.docs[index]
                    .data()["ChatroomId"]
                    .toString()
                    .replaceAll(Constants.myName, "")
                    .replaceAll("_", ""),
                chatRoomId:
                    snapshot.data.docs[index].data()["ChatroomId"].toString());
          },
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUsernameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Container(margin: EdgeInsets.only(top: 8), child: chatRoomList()),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomsTile({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: Text(
                "${username.substring(0, 1).toUpperCase()}",
                style: largeTextStyle(),
              ),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            SizedBox(width: 12),
            Text(
              username,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
