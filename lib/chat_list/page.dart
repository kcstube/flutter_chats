import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/create_chat/page.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:intl/intl.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({
    Key? key,
    required this.myUserId,
  }) : super(key: key);

  final String myUserId;

  @override
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> chatQuery =
        FirebaseFirestore.instance.collection("chats");
    return Scaffold(
        appBar: AppBar(
          title: const Text("チャット一覧"),
        ),
        body: FirestoreListView<Map<String, dynamic>>(
          query: chatQuery,
          itemBuilder: (BuildContext context, snapshot) {
            final data = snapshot.data();
            final chatName = data["name"] as String;
            final startedAt = data["startedAt"] as Timestamp;
            final formatter = DateFormat.yMd().add_Hm();
            final startedAtText = formatter.format(startedAt.toDate());
            return ListTile(
              title: Text(chatName),
              subtitle: Text(startedAtText),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // CreateChatPaggeを表示する
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CreateChatPage(
                  myUserId: myUserId,
                );
              },
            );
          },
          label: const Text("新規作成"),
          icon: const Icon(Icons.add),
        ));
  }
}
