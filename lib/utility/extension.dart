import 'package:stack_trace/stack_trace.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


void log(Object object, {int index = 1}) {
  const bool release = const bool.fromEnvironment("dart.vm.product");
  if (!release) {
    var location = Trace.from(StackTrace.current).terse.frames[index].location;
    print("[$location] $object");
  }
}

extension Color on ui.Color {
  static fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return ui.Color(int.parse(hexColor, radix: 16));
  }
}

