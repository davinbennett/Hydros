import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smartirrigation/Pages/welcome_screen/welcome_screen_page.dart';
import 'package:smartirrigation/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'user@user.com',
    password: 'user123',
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
  await initializeDateFormatting('id_ID', null);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => GetMaterialApp(
        getPages: routes.pages,
        debugShowCheckedModeBanner: false,
        home: child,
        locale: const Locale('id', 'ID'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('id', 'ID'),
        ],
        // getPages: routes.pages,
        theme: ThemeData(
          
            primaryColor: Color.fromRGBO(62, 148, 106, 1), useMaterial3: true),
      ),
      designSize: Size(393, 825),
      child: welcomeScreen(),
    );
  }
}
