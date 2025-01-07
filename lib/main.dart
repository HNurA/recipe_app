import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/Provider/quantity.dart';
import 'package:recipe_app/Provider/saved_provider.dart';
import 'package:recipe_app/firebase_options.dart';
import 'package:recipe_app/pages/my_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // for favorite provider
        ChangeNotifierProvider(create: (_) => SavedProvider()),
        // for quantity provider
        ChangeNotifierProvider(create: (_) => QuantityProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}
