import 'package:flutter_test/flutter_test.dart';
import 'package:fontend/main.dart';

void main() {
  testWidgets('ReadingLabApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ReadingLabApp());
    expect(find.text('READING LAB'), findsWidgets);
  });
}
