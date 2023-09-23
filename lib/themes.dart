import "package:flutter/material.dart";
import "package:velocity_x/velocity_x.dart";

import 'consts/colors.dart';


class customTheme{

//creating light theme
  static final lightTheme=ThemeData(
    cardColor:Colors.white,
    fontFamily:"poppins",
    scaffoldBackgroundColor:Vx.white,
    primaryColor:Vx.gray800,
    iconTheme: const IconThemeData(color:Vx.gray600),
  );
//creating dark theme

  static final darkTheme=ThemeData(
    cardColor:bgColor,
    fontFamily: "poppins",
    scaffoldBackgroundColor: bgColor,
    primaryColor: Vx.white,
    iconTheme: const IconThemeData(color:Vx.white),
  );
} 