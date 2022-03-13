import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/chat_list/page.dart';
import 'package:flutter_chats/user_settings/page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      home: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, snapshot) {
          final myUserId = snapshot.data;
          if (myUserId == null) {
            return const UserSettingsPage();
          }
          return ChatListPage(
            myUserId: myUserId,
          );
        },
      ),
    );
  }

  Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    // ユーザー名を登録していなければ、idは`null`が代入される
    return id;
  }
}

// 日付をフォーマットして文字列を返す関数
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final bool isSameDay = now.difference(dateTime) < const Duration(days: 1);
  final DateFormat dateFormatter;
  if (isSameDay) {
    dateFormatter = DateFormat.Hm();
  } else {
    dateFormatter = DateFormat('yyyy/MM/dd HH:mm');
  }
  return dateFormatter.format(dateTime);
}
