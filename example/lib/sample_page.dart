import 'package:flutter/material.dart';
import 'package:hiro/hiro.dart';

part 'sample_page.g.dart';

@HiroPage()
class SamplePage extends StatelessWidget {
  final String text;
  final Color? color;

  const SamplePage(
    int haha, {
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);

  const SamplePage.blank() : this(0, text: '');

  const SamplePage.named(
    double hehe, {
    Key? key,
    required this.text,
    this.color = const Color(0xFF),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiro example app'),
      ),
      body: Center(
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
