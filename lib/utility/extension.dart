import 'package:stack_trace/stack_trace.dart';
import 'dart:ui';


void log(Object object, {int index = 1}) {
  const bool release = const bool.fromEnvironment("dart.vm.product");
  if (!release) {
    var location = Trace.from(StackTrace.current).terse.frames[index].location;
    print("[$location] $object");
  }
}

extension ColorExtension on Color {
  static Color fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

extension StringExtension on String {
  bool isNullOrEmpty() {
    return this == null || this.isEmpty;
  }
}

