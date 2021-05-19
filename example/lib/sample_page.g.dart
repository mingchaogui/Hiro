// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_page.dart';

// **************************************************************************
// HiroPageGenerator
// **************************************************************************

class $SamplePageArgs {
  final int haha;
  final Key key;
  final String text;
  final Color? color;
  $SamplePageArgs(
    this.haha, {
    required this.key,
    required this.text,
    this.color,
  });
}

Widget $generateSamplePage(dynamic arguments) {
  if (arguments is! $SamplePageArgs)
    throw HiroArgumentsException(arguments: arguments);
  return SamplePage(
    arguments.haha,
    key: arguments.key,
    text: arguments.text,
    color: arguments.color,
  );
}

class $SamplePageNamedArgs {
  final double hehe;
  final Key key;
  final String text;
  final Color? color;
  $SamplePageNamedArgs(
    this.hehe, {
    required this.key,
    required this.text,
    this.color = const Color(255),
  });
}

Widget $generateSamplePageNamed(dynamic arguments) {
  if (arguments is! $SamplePageNamedArgs)
    throw HiroArgumentsException(arguments: arguments);
  return SamplePage.named(
    arguments.hehe,
    key: arguments.key,
    text: arguments.text,
    color: arguments.color,
  );
}
