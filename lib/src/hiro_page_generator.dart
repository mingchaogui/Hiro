// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

class HiroPageGenerator extends GeneratorForAnnotation<HiroPage> {
  const HiroPageGenerator();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement)
      throw InvalidGenerationSourceError(
          '@HiroPage can only be annotated with class. "${element.thisOrAncestorOfType()}" is not acceptable.');

    final buffer = StringBuffer();

    for (final constructor in element.constructors) {
      // Page参数类
      final argsName =
          '${r'$'}${element.name}${constructor.name.capitalize()}Args';
      buffer.writeln('class $argsName {');
      // 声明属性
      for (final param in constructor.parameters) {
        buffer.writeln('final ${param.type} ${param.name};');
      }
      buffer.writeln('$argsName(');
      // 必要位置参数
      _writeConstructorParams(
        buffer,
        constructor.parameters.where((element) => element.isRequiredPositional),
      );
      // 可选位置参数
      _writeConstructorParams(
        buffer,
        constructor.parameters.where((element) => element.isOptionalPositional),
        prefix: '[',
        suffix: ']',
      );
      // 具名参数
      _writeConstructorParams(
        buffer,
        constructor.parameters.where((element) => element.isNamed),
        prefix: '{',
        suffix: '}',
      );
      buffer.writeln(');}');

      // Page生成函数
      final funcName =
          '${r'$'}generate${element.name}${constructor.name.capitalize()}';
      buffer.writeln('Widget $funcName(dynamic arguments) {');
      buffer.writeln(
          'if (arguments is! $argsName) throw HiroArgumentsException(arguments: arguments);');
      if (constructor.name.isEmpty) {
        buffer.writeln('return ${element.name}(');
      } else {
        buffer.writeln('return ${element.name}.${constructor.name}(');
      }
      for (final param in constructor.parameters) {
        if (param.isNamed) buffer.write('${param.name}: ');
        buffer.writeln('arguments.${param.name},');
      }
      buffer.writeln(');}');
    }

    return buffer.toString();
  }

  void _writeConstructorParams(
    StringBuffer buffer,
    Iterable<ParameterElement> params, {
    String? prefix,
    String? suffix,
  }) {
    if (params.isEmpty) return;
    if (prefix != null) buffer.writeln(prefix);
    for (final param in params) {
      if (param.isRequiredNamed) buffer.write('required ');
      buffer.write('this.${param.name}');
      if (param.hasDefaultValue) buffer.write(' = ${param.defaultValueCode}');
      buffer.writeln(',');
    }
    if (suffix != null) buffer.write(suffix);
  }
}

extension _StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
