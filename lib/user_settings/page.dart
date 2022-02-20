import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/chat_list/page.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ユーザー名の登録"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "公開する自分のニックネーム（ユーザー名）を登録しましょう。",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(24),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextField(
                        controller: _textEditingController,
                        decoration: const InputDecoration(
                          label: Text("ユーザー名"),
                          hintText: "ユーザー名を入力しよう！（1文字以上）",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final String myUserId =
                        await _upsertUserName(_textEditingController.text);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        settings: const RouteSettings(name: "/chat_list"),
                        builder: (context) => ChatListPage(
                          myUserId: myUserId,
                        ),
                      ),
                    );
                  } catch (err) {
                    print(err);
                  }
                },
                child: Text(
                  "決定",
                  style: Theme.of(context).textTheme.button?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _upsertUserName(String userName) async {
    final firestore = FirebaseFirestore.instance;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final document = firestore.collection("users").doc();
    final data = {
      "id": document.id,
      "name": userName,
    };
    await document.set(data);
    sharedPreferences.setString("user_id", document.id);
    return document.id;
  }
}
