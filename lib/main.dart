import 'package:dynamic_sidebar/bloc/sidebar/sidebar_bloc.dart';
import 'package:dynamic_sidebar/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menu App'),
        ),
        // drawer: const Sidebar(),
        body: const Sidebar(),
      ),
    );
  }
}