import 'dart:core' as core;
import 'package:stack_trace/stack_trace.dart';

void print(core.Object object, {core.int index = 1}) {
  const core.bool release = const core.bool.fromEnvironment("dart.vm.product");
  if (!release) {
    var location = Trace.from(core.StackTrace.current).terse.frames[index].location;
    core.print("[$location] $object");
  }
}