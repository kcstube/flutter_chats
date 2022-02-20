import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chats/chat_list/page.dart';
import 'package:flutter_chats/user_settings/page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        )
      ),
      home: FutureBuilder<Widget>(
        future: selectRootPage(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.requireData;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Widget> selectRootPage(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? userId = sharedPreferences.getString("user_id");
    if (userId == null) {
      return const UserSettingsPage();
    } else {
      return ChatListPage(myUserId: userId,);
    }
  }
}

// FIXME: Util関数群
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