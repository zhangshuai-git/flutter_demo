import 'package:stack_trace/stack_trace.dart';

void log(Object object, {int index = 1}) {
  const bool release = const bool.fromEnvironment("dart.vm.product");
  if (!release) {
    var location = Trace.from(StackTrace.current).terse.frames[index].location;
    print("[$location] $object");
  }
}