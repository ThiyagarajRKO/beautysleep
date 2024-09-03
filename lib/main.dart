import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:phillips_hue/routes/app_pages.dart';
import 'package:phillips_hue/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Provider/MenuProvider.dart';
import 'UI/HomeScreen.dart';
import 'Utilis/app_preference.dart';
import 'Utilis/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreference().init();

  runApp(
    ChangeNotifierProvider<MenuProvider>(
      create: (_) => MenuProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor,
      statusBarIconBrightness: Brightness.dark,
    ));

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GetMaterialApp(
            builder: (BuildContext context, Widget? child) {
              final mediaQueryData = MediaQuery.of(context);
              final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
              return MediaQuery(
                data: mediaQueryData.copyWith(
                    textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            home: LoaderOverlay(child: HomeScreen()),
            // home: const BridgeControlScreen(title: "Bridge HUE",),
            debugShowCheckedModeBanner: false,
            title: 'Beauty Sleep',
            initialRoute: AppRoutes.root.toName,
            getPages: AppPages.list,
            theme: ThemeData.light().copyWith(
              // Set the white theme
              primaryColor: AppTheme.primaryColor,
              scaffoldBackgroundColor: AppTheme.primaryColor,
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
              textTheme: GoogleFonts.montserratTextTheme(
                  Theme.of(context).textTheme.apply(
                        bodyColor: AppTheme.primaryColor,
                        displayColor: AppTheme.primaryColor,
                      )),
            ));
      },
    );
  }
}
