import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/chat_detail/page.dart';
import 'package:flutter_chats/create_chat/page.dart';
import 'package:flutterfire_ui/firestore.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    Key? key,
    required this.myUserId,
  }) : super(key: key);

  final String myUserId;

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection("chats").orderBy("startedAt");
    return Scaffold(
      appBar: AppBar(
        title: const Text("チャットリスト"),
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        query: query,
        itemBuilder: (context, snapshot) {
          final Map<String, dynamic> data = snapshot.data();
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/chat_detail"),
                  builder: (context) => ChatDetailPage(
                    chat: data,
                    myUserId: widget.myUserId,
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text("${data["name"]}"),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => CreateChatPage(
              myUserId: widget.myUserId,
            ),
          );
        },
        label: const Text("作成"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
