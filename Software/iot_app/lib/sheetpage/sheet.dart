import 'dart:async';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../action button/button.dart';
import '../api/api.dart';
import '../main.dart';
import 'dart:math' as math;


class CreateSheetsPage extends StatefulWidget {
  const CreateSheetsPage({super.key});

  @override
  _CreateSheetsPageState createState() => _CreateSheetsPageState();
}

class _CreateSheetsPageState extends State<CreateSheetsPage> {
  double lightLevel = 0;
  double humidityLevel = 0;
  String pumpStatus = "OFF";
  late String lightTime;
  late String humidityTime;
  late Timer _timer;
  bool isAutoWateringEnabled = false;
  // Declare two new lists to hold light and humidity levels
  List<double> lightLevelList = [];
  List<double> humidityLevelList = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo Timer để cập nhật dữ liệu mỗi 5 giây
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchData();
    });
  }

  @override
  void dispose() {
    // Hủy timer để tránh rò rỉ bộ nhớ
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchData();
    });
  }

  void toggleAutoWatering() {
    setState(() {
      isAutoWateringEnabled = !isAutoWateringEnabled;
    });
    if (isAutoWateringEnabled) {
      // Call function to start automatic watering
      startAutoWatering();
    } else {
      // Call function to stop automatic watering
      stopAutoWatering();
    }
  }
  void startAutoWatering() {
    // Add your code to start automatic watering here
    if (kDebugMode) {
      print('Automatic watering started');
    }
  }
  // Simulated function to stop automatic watering
  void stopAutoWatering() {
    // Add your code to stop automatic watering here
    if (kDebugMode) {
      print('Automatic watering stopped');
    }
  }

  Future<void> fetchData() async {
    final data = await UserSheetApi.retrieveData();
    updateData(data!);
  }

  void updateData(List<Map<String, dynamic>> data) {
    // Clear previous data
    lightLevelList.clear();
    humidityLevelList.clear();

    // Populate the lists with new data
    for (var record in data) {
      if (record.containsKey('Light')) {
        var lightValue = double.tryParse(record['Light'].toString()) ?? 0;
        lightLevelList.add(lightValue);
      }
      if (record.containsKey('Humidity')) {
        var humidityValue = double.tryParse(record['Humidity'].toString()) ?? 0;
        humidityLevelList.add(humidityValue);
      }
    }

    // Optionally update the last record to the UI
    if (data.isNotEmpty) {
      final lastRecord = data.last;
      setState(() {
        lightLevel = lightLevelList.last;
        humidityLevel = humidityLevelList.last;
        pumpStatus = lastRecord['Pump'].toString();
        lightTime = lastRecord['timeLight'].toString();
        humidityTime = lastRecord.containsKey('timeHumidity') ? lastRecord['timeHumidity'].toString() : humidityTime;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Anh Trung - Kien Nguyen',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple[200], // Màu nền tím nhạt
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20), // Bo góc dưới trái
               // Bo góc dưới phải
            ),
          ),
          centerTitle: true, // Căn giữa tiêu đề
          actions: [
            MainMenuButton(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Expanded(
                    child: InfoBox(
                      icon: 'assets/Light.png',
                      label: 'Light Level',
                      value: '${lightLevel.toStringAsFixed(2)}%',
                      key: const ValueKey('light_parameter'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: InfoBox(
                      icon: 'assets/humidity.png',
                      label: 'Humidity Level',
                      value: '${humidityLevel.toStringAsFixed(2)}%',
                      key: const ValueKey('humidity_parameter'),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Gọi hàm để xuất Excel khi nút được nhấn
                  exportToExcel(lightLevelList, humidityLevelList);
                },
                child: const Text('Export to Excel'),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Auto Watering: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Switch(
                      value: isAutoWateringEnabled,
                      onChanged: (value) {
                        toggleAutoWatering();
                      },
                    ),
                  ],

                ),
              ),
              const SizedBox(height: 40),

            ],
          ),
        ),

        bottomNavigationBar: Container(
          width: double.infinity, // Đặt chiều rộng của Container bằng độ rộng tối đa
          height: 130,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            //border: Border.all(color: Colors.black), // Thêm border
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tran Dao Anh Trung   21139085 '
                    '\nNguyen Kien Nguyen 21139045',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/ute.png',
                width: 124.9,
                height: 124.9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> exportToExcel(List<double> lightLevel, List<double> humidityLevel) async {
  // Lấy thư mục tạm thời
  var tempDir = await getTemporaryDirectory();
  var path = tempDir.path;
  int index = lightLevel.length;
  // Tạo một workbook mới
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];
  sheet.appendRow([
    TextCellValue('Light'),
    TextCellValue('Humidity')
  ]);
  // Thêm dữ liệu vào sheet
  for(int i = 0; i < index; i++) {
    sheet.appendRow([
      TextCellValue(lightLevel[i].toString()),
      TextCellValue(humidityLevel[i].toString())
    ]);
  }

  // Lấy đường dẫn đến thư mục Download
  String downloadsPath = '/storage/emulated/0/Download';

  // Tạo đường dẫn đến file Excel trong thư mục Download
  var file = '$downloadsPath/example.xlsx';

  // Lưu workbook xuống đĩa
  final onValue = await excel.encode();
  if (onValue != null) {
    File(file)
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
  } else {
    // Xử lý trường hợp không có dữ liệu từ excel.encode()
  }

  print('Excel file exported to: $file');
}

