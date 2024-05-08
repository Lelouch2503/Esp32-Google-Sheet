//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../action button/button.dart';
// import '../api/api.dart';
//
// class Graph extends StatefulWidget {
//   const Graph({super.key, required this.title});
//
//   final String title;
//
//   @override
//   _Graph createState() => _Graph();
// }
//
// class _Graph extends State<Graph> {
//   late List<LiveData> chartData;
//   late List<LiveData> chartData1;
//   late ChartSeriesController _chartSeriesController;
//   late String text;
//   late Timer _timer;
//   double lightLevel = 0;
//   double humidityLevel = 0;
//   late String lightTime;
//   late String humidityTime;
//
//   @override
//   void initState() {
//     super.initState();
//     chartData = []; // Khởi tạo danh sách trống
//     Timer.periodic(const Duration(seconds: 3), updateDataSource);
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       fetchData();
//     });
//   }
//
//   @override
//   void dispose() {
//     // Hủy timer để tránh rò rỉ bộ nhớ
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 5), (_) {
//       fetchData();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.title == "Light") {
//       text = "Light Intensity";
//     }
//     else if(widget.title == "Humidity"){
//       text = "Humidity(%)";
//     }
//     else
//     {
//       text = "Loading";
//     }
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Anh Trung - Kien Nguyen',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.purple[200], // Màu nền tím nhạt
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20), // Bo góc dưới trái
//             ),
//           ),
//           centerTitle: true, // Căn giữa tiêu đề
//           actions: [
//             MainMenuButton(),
//           ],
//         ),
//         body: ListView(
//           padding: const EdgeInsets.all(8),
//           children: [
//
//             const SizedBox(height: 60,),
//
//             SizedBox(height: MediaQuery.of(context).size.height * 0.3, // Đặt chiều cao của biểu đồ
//               child: SfCartesianChart(
//                 series: <LineSeries<LiveData, DateTime>>[
//                   LineSeries<LiveData, DateTime>(
//                     animationDuration: 2000, // Thời gian animation là 1500 milliseconds (1.5 giây)
//                     enableTooltip: true,
//                     onRendererCreated: (ChartSeriesController controller) {
//                       _chartSeriesController = controller;
//                     },
//                     dataSource: chartData,
//                     color: const Color.fromRGBO(192, 108, 132, 1),
//                     xValueMapper: (LiveData sales, _) => sales.time,
//                     yValueMapper: (LiveData sales, _) => sales.speed,
//                     // width: 0.4,
//                   )
//                 ],
//                 primaryXAxis: DateTimeAxis(
//                   majorGridLines: const MajorGridLines(width: 0.5),
//                   edgeLabelPlacement: EdgeLabelPlacement.shift,
//                   interval: 3,
//                   // maximum: 30,
//                   dateFormat: DateFormat.Hm(), // 'H' cho giờ trong ngày (0-23), 'm' cho phút, 's' cho giây
//                   title: const AxisTitle(text: 'Time (HH:MM)'),
//                 ),
//                 primaryYAxis: NumericAxis(
//                     axisLine: const AxisLine(width: 0),
//                     majorTickLines: const MajorTickLines(size: 0),
//                     title: AxisTitle(text: text)),
//               ),)
//           ],
//         ),
//         bottomNavigationBar: Container(
//           width: double.infinity, // Đặt chiều rộng của Container bằng độ rộng tối đa
//           height: 130,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//             border: Border.all(color: Colors.black), // Thêm border
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Tran Dao Anh Trung   21139085 '
//                     '\nNguyen Kien Nguyen 21139045',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Image.asset(
//                 'assets/ute.png',
//                 width: 124.9,
//                 height: 124.9,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void fetchData() async {
//     final data = await UserSheetApi.retrieveData();
//     updateData(data!);
//   }
//
//   void updateData(List<Map<String, dynamic>> data) {
//     if (data.isNotEmpty) {
//       final lastRecord = data.last;
//       if (lastRecord.containsKey('Light')) {
//         setState(() {
//           lightLevel = double.tryParse(lastRecord['Light'].toString()) ?? 0;
//         });
//       }
//       if (lastRecord.containsKey('Humidity')) {
//         setState(() {
//           humidityLevel = double.tryParse(lastRecord['Humidity'].toString()) ?? 0;
//         });
//       }
//       if (lastRecord.containsKey('timeLight')) {
//         setState(() {
//           lightTime = lastRecord['timeLight'].toString();
//         });
//       }
//       if (lastRecord.containsKey('timeHumidity')) {
//         setState(() {
//           humidityTime = lastRecord['timeHumidity'].toString();
//         });
//       }
//     }
//   }
//
//   void updateDataSource(Timer timer) {
//     //final random = math.Random();
//     final nextTime = chartData.isNotEmpty ? chartData.last.time.add(Duration(seconds: 3)) : DateTime.now();
//     //final nextSpeed = random.nextInt(61) + 30; // Giữ nguyên logic tạo tốc độ ngẫu nhiên
//
//     // Cập nhật logic xử lý dữ liệu tương tự, nhưng sử dụng DateTime
//     if (chartData.length == 6) {
//       chartData.removeAt(0);
//       _chartSeriesController.updateDataSource(
//         addedDataIndex: chartData.length - 1,
//         removedDataIndex: 0,
//       );
//     }
//
//     chartData.add(LiveData(nextTime, lightLevel));
//
//     if (chartData.length < 6) {
//       _chartSeriesController.updateDataSource(
//         addedDataIndex: chartData.length - 1,
//       );
//     }
//   }
// }
//
// class LiveData {
//   LiveData(this.time, this.speed);
//   final DateTime time;
//   final num speed;
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../action button/button.dart';
import '../api/api.dart';

class Graph extends StatefulWidget {
  const Graph({super.key, required this.title});

  final String title;

  @override
  _Graph createState() => _Graph();
}

class _Graph extends State<Graph> {
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
            ),
          ),
          centerTitle: true, // Căn giữa tiêu đề
          actions: [
            MainMenuButton(),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: const [
            SizedBox(height: 30,),
            DrawGraph(title: "Light"),
            SizedBox(height: 60,),
            DrawGraph(title: "Humidity"),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity, // Đặt chiều rộng của Container bằng độ rộng tối đa
          height: 130,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.black), // Thêm border
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
class DrawGraph extends StatefulWidget {
  final String title;

  const DrawGraph({Key? key, required this.title}) : super(key: key);

  @override
  _DrawGraphState createState() => _DrawGraphState();
}

class _DrawGraphState extends State<DrawGraph> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  late String text;
  late List<double> lightLevelList;
  late Timer _timer;
  double lightLevel = 0;
  double humidityLevel = 0;
  late String lightTime;
  late String humidityTime;

  @override
  void initState() {
    super.initState();
    chartData = []; // Khởi tạo danh sách trống
    Timer.periodic(const Duration(seconds: 2), updateDataSource);
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
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
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == "Light") {
      text = "Light Intensity";
    } else if (widget.title == "Humidity") {
      text = "Humidity(%)";
    } else {
      text = "Loading";
    }
    return SizedBox(height: MediaQuery.of(context).size.height * 0.3, // Đặt chiều cao của biểu đồ
      child: SfCartesianChart(
        series: <LineSeries<LiveData, DateTime>>[
          LineSeries<LiveData, DateTime>(
            animationDuration: 2000, // Thời gian animation là 1500 milliseconds (1.5 giây)
            enableTooltip: true,
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (LiveData sales, _) => sales.time,
            yValueMapper: (LiveData sales, _) => sales.speed,
            // width: 0.4,
          )
        ],
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0.5),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1,
          // maximum: 30,
          dateFormat: DateFormat.Hm(), // 'H' cho giờ trong ngày (0-23), 'm' cho phút, 's' cho giây
          title: const AxisTitle(text: 'Time (HH:MM)'),
        ),
        primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            title: AxisTitle(text: text)),
      ),
    );
  }

  void fetchData() async {
    final data = await UserSheetApi.retrieveData();
    updateData(data!);
  }

  void updateData(List<Map<String, dynamic>> data) {
    if (data.isNotEmpty) {
      final lastRecord = data.last;
      if (lastRecord.containsKey('Light')) {
        setState(() {
          lightLevel = double.tryParse(lastRecord['Light'].toString()) ?? 0;
        });
      }
      if (lastRecord.containsKey('Humidity')) {
        setState(() {
          humidityLevel = double.tryParse(lastRecord['Humidity'].toString()) ?? 0;
        });
      }
      if (lastRecord.containsKey('timeLight')) {
        setState(() {
          lightTime = lastRecord['timeLight'].toString();
        });
      }
      if (lastRecord.containsKey('timeHumidity')) {
        setState(() {
          humidityTime = lastRecord['timeHumidity'].toString();
        });
      }
    }
  }

  void updateDataSource(Timer timer) {
    //final random = math.Random();
    final nextTime = chartData.isNotEmpty ? chartData.last.time.add(Duration(seconds: 3)) : DateTime.now();
    //final nextSpeed = random.nextInt(61) + 30; // Giữ nguyên logic tạo tốc độ ngẫu nhiên

    // Cập nhật logic xử lý dữ liệu tương tự, nhưng sử dụng DateTime
    if (chartData.length == 6) {
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );
    }

    if(widget.title == 'Light') {
      chartData.add(LiveData(nextTime, lightLevel));
    } else{
      chartData.add(LiveData(nextTime, humidityLevel));
    }

    if (chartData.length < 6) {
      _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1,
      );
    }
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final DateTime time;
  final num speed;
}
