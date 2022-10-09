import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SizeConfig {
  factory SizeConfig() => _instance;
  SizeConfig._();

  static final SizeConfig _instance = SizeConfig._();
  MediaQueryData? _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  double? blockSizeHorizontal;
  double? blockSizeVertical;
  double? deviceTextFactor;

  double? _safeAreaHorizontal;
  double? _safeAreaVertical;
  double? safeBlockHorizontal;
  double? safeBlockVertical;

  double? profileDrawerWidth;
  double refHeight = 812;
  double refWidth = 375;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;

    deviceTextFactor = _mediaQueryData!.textScaleFactor;

    if (screenHeight < 1200) {
      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;

      _safeAreaHorizontal =
          _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
      _safeAreaVertical =
          _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
      safeBlockHorizontal = (screenWidth - _safeAreaHorizontal!) / 100;
      safeBlockVertical = (screenHeight - _safeAreaVertical!) / 100;
    } else {
      blockSizeHorizontal = screenWidth / 120;
      blockSizeVertical = screenHeight / 120;

      _safeAreaHorizontal =
          _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
      _safeAreaVertical =
          _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
      safeBlockHorizontal = (screenWidth - _safeAreaHorizontal!) / 120;
      safeBlockVertical = (screenHeight - _safeAreaVertical!) / 120;
    }
  }

  double getWidthRatio(double val) {
    final res = (val / refWidth) * 100;
    final temp = res * blockSizeHorizontal!;

    return temp;
  }

  double getHeightRatio(double val) {
    final res = (val / refHeight) * 100;
    final temp = res * blockSizeVertical!;
    final widthTemp = getWidthRatio(val);
    return widthTemp > temp ? widthTemp : temp;
  }

  double getFontRatio(double val) {
    final res = (val / refWidth) * 100;
    var temp = 0.0;
    if (screenWidth < screenHeight) {
      temp = res * safeBlockHorizontal!;
    } else {
      temp = res * safeBlockVertical!;
    }
    return temp;
  }
}

extension SizeUtils on num {
  //ignore: unnecessary_this
  double get toWidth => SizeConfig().getWidthRatio(this.toDouble());
//ignore: unnecessary_this
  double get toHeight => SizeConfig().getHeightRatio(this.toDouble());
//ignore: unnecessary_this
  double get toFont => SizeConfig().getFontRatio(this.toDouble());

  String toCurrency({int decimal = 0}) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: decimal)
          .format(this)
          .trim();
}

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
    return const Color(0xff000000);
  }
}

extension DateFormatter on String {
  String get toMDY => this == ''
      ? ''
      : DateFormat.yMMMd().format(DateTime.parse(this)).toString();

  String get hm => this == ''
      ? ''
      : DateFormat().add_jm().format(DateTime.parse(this)).toString();

  bool get isNum {
    return double.tryParse(this) != null;
  }
}

extension MonthAddition on DateTime {
  DateTime addMonth(int addedMonth) {
    final monthAdded = month + addedMonth;
    final monthToAdd =
        '$monthAdded'.length == 1 ? '0$monthAdded' : '$monthAdded';
    final dateDay = '$day'.length == 1 ? '0$day' : '$day';
    if ((month + addedMonth) > 99) {
      final date = DateTime.parse('$year-99-$dateDay');
      final nextDayDate =
          '${date.day}'.length == 1 ? '0${date.day}' : '${date.day}';
      return DateTime.parse(
        '${date.year}-${date.month + (monthAdded - 99)}-$nextDayDate',
      );
    } else {
      return DateTime.parse('$year-$monthToAdd-$dateDay');
    }
  }
}
