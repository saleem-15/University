import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    cardTheme: cardTheme,
    dialogTheme: dialogTheme,
    popupMenuTheme: popupMenuThemeData,
    inputDecorationTheme: inputDecorationTheme,
    textButtonTheme: textButtonTheme,
    primaryTextTheme: generalTextTheme,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    //all buttons and text fields borders use primary swatch by default
    primarySwatch: Colors.teal,
    //the border of drop down boxes is set to use primary color
    primaryColor: Colors.teal,

    cardTheme: cardTheme,
    dialogTheme: dialogTheme,
    popupMenuTheme: popupMenuThemeData,
    inputDecorationTheme: inputDecorationTheme,
    textButtonTheme: textButtonTheme,
    primaryTextTheme: generalTextTheme,
  );

//******************************* Themes specific for each component of the app *******************************
  static TextTheme generalTextTheme = const TextTheme(
      // titleLarge: TextStyle(fontSize: 26 ,color:text ),
      //  bodyLarge: TextStyle(fontSize: 26),
      );
  static CardTheme cardTheme = CardTheme(
    elevation: 7,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );

  static DialogTheme dialogTheme = DialogTheme(
    //backgroundColor: const Color.fromARGB(199, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  static PopupMenuThemeData popupMenuThemeData = PopupMenuThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
    //constraints: BoxConstraints(maxHeight: 50),  => this makes the textfield a bit more nice
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  static TextButtonThemeData textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
    ),
  );

/*How to define a MaterialColor
      MaterialColor(
      0xFF000000,
      <int, Color>{
        50: Color(0xFFE8EAF6),  => the value of each color is written like this  (0x.....) 
        100: Color(0xFFC5CAE9),
        200: Color(0xFF9FA8DA),
        300: Color(0xFF7986CB),
        400: Color(0xFF5C6BC0),
        500: Color(0xFF000000),
        600: Color(0xFF3949AB),
        700: Color(0xFF303F9F),
        800: Color(0xFF283593),
        900: Color(0xFF000000),
      },
    )
  */

}
