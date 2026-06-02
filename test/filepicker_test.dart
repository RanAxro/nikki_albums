import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  testWidgets('Test file picker', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              try {
                print("Button pressed");
                final output = await FilePicker.platform.saveFile(
                  dialogTitle: "export",
                  fileName: "test.gif",
                );
                print("Output: $output");
              } catch (e) {
                print("Error: $e");
              }
            },
            child: Text('Save'),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  });
}
