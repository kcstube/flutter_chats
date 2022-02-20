import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:gap/gap.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({
    Key? key,
    required this.myUserId,
  }) : super(key: key);

  final String myUserId;

  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> usersQuery =
        FirebaseFirestore.instance.collection("users").where(
              "id",
              isNotEqualTo: widget.myUserId,
            );
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(24),
            Text(
              "新しくチャットを始めましょう！",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
            ),
            const Gap(8),
            // TODO: 検索機能追加
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: TextField(
            //     controller: _textEditingController,
            //     decoration: const InputDecoration(
            //       hintText: "チャット先のユーザーを探す",
            //       label: Text("ユーザー名"),
            //     ),
            //   ),
            // ),
            // const Gap(8),
            Text(
              "ユーザーリスト",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const Gap(4),
            SizedBox(
              height: 300,
              child: FirestoreListView<Map<String, dynamic>>(
                  query: usersQuery,
                  itemBuilder: (context, snapshot) {
                    final Map<String, dynamic> data = snapshot.data();
                    return GestureDetector(
                      onTap: () async {
                        await _selectChatUser(
                          userData: data,
                          myUserId: widget.myUserId,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        elevation: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          child: ListTile(
                            title: Text(
                              "${data["name"]}",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: Image.network(
                                  // TODO: Pick Image from Gallary.
                                  "https://via.placeholder.com/150",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _selectChatUser({
    required Map<String, dynamic> userData,
    required String myUserId,
  }) async {
    final String userId = userData["id"]!;
    final String userName = userData["name"]!;
    final String chatName = "Chat Room with $userName";
    final document = FirebaseFirestore.instance.collection("chats").doc();
    final Map<String, dynamic> data = {
      "id": document.id,
      "name": chatName,
      "users": [
        userId,
        myUserId,
      ],
      "startedAt": Timestamp.now(),
    };
    await document.set(data);
  }
}
