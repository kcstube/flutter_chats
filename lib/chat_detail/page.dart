import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/main.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:gap/gap.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({
    Key? key,
    required this.chat,
    required this.myUserId,
  }) : super(key: key);

  final Map<String, dynamic> chat;
  final String myUserId;

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String chatId = widget.chat["id"]!;
    final Query<Map<String, dynamic>> messagesQuery = FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("postedAt");
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.chat["name"]}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: FirestoreListView<Map<String, dynamic>>(
                query: messagesQuery,
                itemBuilder: (context, snapshot) {
                  final data = snapshot.data();
                  final bool isMine = data["sender"] == widget.myUserId;
                  final DateTime postedAt = (data["postedAt"] as Timestamp).toDate();
                  return Column(
                    crossAxisAlignment: isMine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      FirestoreQueryBuilder<Map<String, dynamic>>(
                        query: FirebaseFirestore.instance
                            .collection("users")
                            .where("id", isEqualTo: data["sender"]),
                        builder: (context, snapshot, _) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          final data = snapshot.docs[0].data();
                          return Text(
                            "${data["name"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(fontWeight: FontWeight.w600),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildMessageCard(chat: data, isMine: isMine),
                      ),
                      Text(formatDateTime(postedAt)),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
            const Gap(24),
            Flexible(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: "メッセージを入力",
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      _sendMessage(_textEditingController.text);
                    },
                    icon: const Icon(Icons.send),
                    label: Text(
                      "送信",
                      style: Theme.of(context).textTheme.button?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard({
    required Map<String, dynamic> chat,
    required bool isMine,
  }) {
    return Card(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              "${chat["message"]}",
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _sendMessage(String message) async {
    final doc = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chat["id"]!)
        .collection("messages")
        .doc();
    final Map<String, dynamic> data = {
      "id": doc.id,
      "sender": widget.myUserId,
      "message": message,
      "isRead": false,
      "postedAt": Timestamp.now(),
    };
    await doc.set(data);
  }
}
