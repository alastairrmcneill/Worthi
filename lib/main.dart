import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/support/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({Key? key, required this.prefs}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService.appUserStream,
          initialData: null,
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (_) => UserNotifier(),
        ),
        ChangeNotifierProvider<AccountNotifier>(
          create: (_) => AccountNotifier(),
        ),
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(
            currency: prefs.getString('currency') ?? '£',
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Moolah',
        debugShowCheckedModeBanner: false,
        theme: MyThemes.theme,
        home: ShowCaseWidget(
          builder: Builder(builder: (_) => const Wrapper()),
          onFinish: () {
            prefs.setBool('showHomePageShowcase', false);
          },
        ),
      ),
    );
  }
}
