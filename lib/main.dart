import "package:ecommerce_app/views/splash_screen/splash_sreen.dart";
import "package:ecommerce_app/consts/consts.dart";
import "package:ecommerce_app/firebase_options.dart";
import "package:firebase_core/firebase_core.dart";
import "package:get/get_navigation/src/root/get_material_app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: redColor),
        scaffoldBackgroundColor: lightGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: whiteColor,
          surfaceTintColor: whiteColor,
          elevation: 0,
          iconTheme: IconThemeData(color: darkFontGrey),
        ),
        cardTheme: const CardThemeData(
          color: whiteColor,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        fontFamily: regular,
      ),
      home: SplashScreen(),
    );
  }
}
