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
      final argsClassName =
          '${r'$'}${element.name}${constructor.name.capitalize()}Args';

      // Page Args Class
      _writeArgsClass(buffer, constructor, className: argsClassName);
      // Page Builder Function
      _writePageBuilder(
        buffer,
        constructor,
        pageClassName: element.name,
        argsClassName: argsClassName,
      );
    }

    return buffer.toString();
  }

  void _writeArgsClass(
    StringBuffer buffer,
    ConstructorElement constructor, {
    required String className,
  }) {
    // No parameters
    if (constructor.parameters.isEmpty) return;

    buffer.writeln('class $className {');
    // 声明属性
    for (final param in constructor.parameters) {
      buffer.writeln('final ${param.type} ${param.name};');
    }
    buffer.writeln('$className(');
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
  }

  void _writePageBuilder(
    StringBuffer buffer,
    ConstructorElement constructor, {
    required String pageClassName,
    required String argsClassName,
  }) {
    final funcName =
        '${r'$'}build$pageClassName${constructor.name.capitalize()}';
    buffer
        .writeln('Widget $funcName(BuildContext context, dynamic arguments) {');
    if (constructor.parameters.isNotEmpty) {
      // 参数校验
      buffer.writeln(
          'if (arguments is! $argsClassName) throw HiroArgumentsException(arguments: arguments);');
    }
    if (constructor.name.isEmpty) {
      buffer.writeln('return $pageClassName(');
    } else {
      buffer.writeln('return $pageClassName.${constructor.name}(');
    }
    for (final param in constructor.parameters) {
      if (param.isNamed) buffer.write('${param.name}: ');
      buffer.writeln('arguments.${param.name},');
    }
    buffer.writeln(');}');
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
