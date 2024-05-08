import 'package:flutter/material.dart';
import '../graph/graph.dart';
import '../sheetpage/sheet.dart';

class MainMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'Màn Hình Chính',
          child: Text('Màn Hình Chính'),
        ),
        const PopupMenuItem(
          value: 'Biểu đồ',
          child: Text('Biểu Đồ'),
        ),
      ],
      onSelected: (value) {
        if (value == 'Màn Hình Chính') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateSheetsPage()),
          );
        } else if (value == 'Biểu đồ') {
          // Đây là nơi bạn sẽ điều hướng đến trang hiển thị biểu đồ Graph
          // Ví dụ:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Graph(title: "Light")
            )
          );
        }
      },
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClicked,
      child: Text(text),
    );
  }
}
