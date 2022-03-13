import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({
    Key? key,
    required this.myUserId,
  }) : super(key: key);

  final String myUserId;

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  // ウィジェットの状態を変更するため、StatefulWidgetを使います
  // 選択しているユーザーの情報を保存
  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    // Query: 複数のFirestore Document
    // Query<Map<String, dynamic>>とすることで、
    // データの型を`Map<String, dynamic>`に指定できる
    // 自分自身とはチャットができないので、自分以外のuserを取得する
    final Query<Map<String, dynamic>> usersQuery =
        FirebaseFirestore.instance.collection("users").where(
              "id",
              isNotEqualTo: widget.myUserId,
            );

    final String selectedUserName = selectedUser?["name"] ?? "";
    final String selectedUserId = selectedUser?["id"] ?? "";

    print("SelectedUserId: $selectedUserName");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "新規チャット",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "ユーザー選択 (選択中: $selectedUserName)",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 64,
              child: FirestoreListView<Map<String, dynamic>>(
                query: usersQuery,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, snapshot) {
                  final data = snapshot.data();
                  final name = data["name"] as String;
                  final id = data["id"] as String;
                  final selectedUserId = selectedUser?["id"];
                  final isSelectedUser = id == selectedUserId;
                  print(data);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedUser = data;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: isSelectedUser
                              ? MaterialStateProperty.all(Colors.blue)
                              : MaterialStateProperty.all(Colors.blueGrey),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                // 自分の情報を取得
                final myUserId = widget.myUserId;
                final myUserData = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(myUserId)
                    .get();
                final myUserName = myUserData.data()?["name"];
                // チャット情報をFirestoreに保存する
                final Map<String, dynamic> data = {
                  "name": "Chat_between_${selectedUserName}_and_${myUserName!}",
                  "users": [
                    myUserId,
                    selectedUserId,
                  ],
                  "startedAt": Timestamp.now(),
                };
                final newDocument =
                    FirebaseFirestore.instance.collection("chats").doc();
                data["id"] = newDocument.id;
                await newDocument.set(data);
                // モーダルを閉じる
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done),
              label: const Text("決定"),
            )
          ],
        ),
      ),
    );
  }
}
