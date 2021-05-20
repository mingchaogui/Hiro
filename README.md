# hiro

Generate arguments class and builder function for widget page.

## Getting Started

Add the part line as such:
```dart
part 'sample_page.g.dart';
```

Annotate your class with @HiroPage
```dart
@HiroPage()
class SamplePage {}
```

Run build_runner
```sh
$ flutter packages pub run build_runner build
```