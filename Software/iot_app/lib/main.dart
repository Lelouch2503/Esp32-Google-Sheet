import 'package:flutter/material.dart';
import 'package:iot_app/api/api.dart';
import 'package:iot_app/sheetpage/sheet.dart';

class InfoBox extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const InfoBox({required Key key, required this.icon, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 160,
            height: 160,
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}



Future main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await UserSheetApi.init();
  runApp(const MaterialApp(
    home: CreateSheetsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
