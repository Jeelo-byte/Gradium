import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:myapp/lib/sign_up_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  const supabaseUrl = 'https://wmzdflyaavexzpymshkf.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtemRmbHlhYXZleHpweW1zaGtmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQxODEzNDAsImV4cCI6MjA2OTc1NzM0MH0.fjWArwzr-NvPQbJbC0MqdXTphNtqW98R-wAntxlx-LA';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gradium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
 home: Scaffold(
 appBar: AppBar(
 title: const Text('Gradium'),
 ),
 body: const Center(
 child: Text('Welcome to Gradium!'),
 ),
 ),

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

    );
  }
}
