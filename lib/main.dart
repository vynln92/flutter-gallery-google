import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_photo_gallery/ui/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'generated/l10n.dart';
import 'model/photos_library_api_model.dart';

void main() {
  final apiModel = PhotosLibraryApiModel();
  apiModel.signInSilently();
  runApp(
    ScopedModel<PhotosLibraryApiModel>(
      model: apiModel,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData _theme = _buildTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: S.of(context).app_name,
      theme: _theme,
      home: HomePage(),
    );
  }
}

ThemeData _buildTheme() {
  final base = ThemeData.light();
  return base.copyWith(
    primaryColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    primaryTextTheme: Typography.blackMountainView,
    primaryIconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    accentColor: Colors.orange[800],
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Colors.orange[800], // foreground
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: Colors.orange[800],
    )),
    scaffoldBackgroundColor: Colors.white,
  );
}
