
import 'package:flutter/material.dart';

import 'pages/menu_list_page.dart';
import 'pages/menu_detail_page.dart';
import 'pages/order_page.dart';
import 'pages/history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuListPage(),
        '/detail': (context) => const MenuDetailPage(),
        '/pesan': (context) => const OrderPage(),
        '/riwayat': (context) => const HistoryPage(),
      },
    );
  }
}
