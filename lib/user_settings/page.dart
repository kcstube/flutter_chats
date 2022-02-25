import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/chat_list/page.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ユーザー名の登録"),
      ),
      body: Column(
        children: [
          const Gap(32),
          const Text("ユーザー名を登録しましょう。"),
          const Gap(24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: "ユーザー名",
              ),
            ),
          ),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: () async {
              DocumentReference ref =
                  FirebaseFirestore.instance.collection("users").doc();
              final Map<String, dynamic> data = {
                "id": ref.id,
                "name": _textEditingController.text,
              };
              // データを保存
              await ref.set(data);
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("id", ref.id);
              // 処理が完了したことを伝える
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("ユーザー名の登録が完了しました"),
                    actions: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // チャット一覧へ画面遷移
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const ChatListPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.navigate_next),
                        label: const Text("次へ"),
                      ),
                    ],
                  );
                },
              );
            },
            label: const Text(
              "保存",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
