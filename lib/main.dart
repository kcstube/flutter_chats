import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
      home: const Center(
        child: CircularProgressIndicator(),
      ),
    );
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
