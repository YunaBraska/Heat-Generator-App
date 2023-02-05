import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(HomeScreen());
}

const List<IconData> icons = [Icons.ac_unit, Icons.wb_sunny, Icons.bubble_chart, Icons.whatshot, Icons.warning];
const List<Color> heatColorsBg = [Colors.blue, Colors.green, Colors.orange, Colors.red];
List<Color> heatColorsText = [Colors.grey[900] ?? Colors.grey, Colors.grey[100] ?? Colors.grey];
Uri donationUrl = Uri.parse('https://www.paypal.com/donate/?hosted_button_id=HFHFUT3G6TZF6');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenImpl createState() => _HomeScreenImpl();
}

class _HomeScreenImpl extends State<HomeScreen> {
  double _sliderValue = 0.0;
  Color _heatColor = heatColorsBg[0];
  Duration _duration = const Duration(milliseconds: 1000);
  int cores = Platform.numberOfProcessors;
  List<Future<Isolate>> threads = List.empty(growable: true);
  IconData _appIcon = icons[0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: Text.rich(TextSpan(children: [
            TextSpan(text: 'Heat Generator ', style: TextStyle(color: heatColorsText[0])),
            WidgetSpan(
              child: Icon(
                _appIcon,
                color: _heatColor,
                size: 24,
              ),
            ),
          ])),
        ),
        body: ListView(
          children: [
            createWidgetRow(Slider(
              min: 0,
              max: 100,
              divisions: 20,
              thumbColor: _heatColor,
              activeColor: _heatColor,
              inactiveColor: Colors.grey[400] ?? Colors.grey,
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                  _duration = Duration(milliseconds: ((100 - value)).floor());
                  _heatColor = getHeatColor(value / 100, heatColorsBg);
                });
                createLoad();
              }
            )),
            // createWidgetRow(InkWell(
            //   onTap: () {
            //     launchUrl(donationUrl);
            //   },
            //   child: const Center(child: Text('By me a coffee (PayPal)', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline))),
            // )),
            createWidgetRow(Container(
                padding: const EdgeInsets.only(left: 8.0),
                // height: 60,
                color: Colors.grey[200],
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      // '* On 100%: UI could freeze. In this case, the UI only reacts again after restarting the app.\n'
                      '* Temperature: cannot be measured because there is no uniform sensor data for all of the devices.\n'
                      '* Battery: The battery wil lbe consumed but not be harmed as the heat comes from the CPU.\n',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    )))),
            createRow('Load Power', '${_sliderValue.toStringAsFixed(0)}%'),
            createRow('Threads', '${threads.length}'),
            createRow('CPU Cores', '${Platform.numberOfProcessors}'),
            createRow('System', '${Platform.operatingSystem} | ${Platform.operatingSystemVersion}'),
            createRow('Runtime Version', Platform.version),
            createRow('Device Name', Platform.localHostname),
            createRow('Language', Platform.localeName),
            createRow('Load duration', '${_sliderValue == 0 ? 0 : _duration.inMilliseconds} ms'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.whatshot),
            label: 'Load Power: ${_sliderValue.toStringAsFixed(0)}%',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.numbers),
            label: 'Threads: ${threads.length}',
            // label: 'Threads: ${Platform.numberOfProcessors - 1}',
          ),
        ], currentIndex: 1),
      ),
    );
  }

  void createLoad() {
    for (var thread in threads) {
      thread.then((isolate) => isolate.kill(priority: Isolate.immediate));
    }
    threads.clear();
    if (_sliderValue > 1) {
      for (int i = 0; i < cores; i++) {
        threads.add(Isolate.spawn<Duration>(_createCpuLoad, _duration, debugName: 'CPU load process [$i]'));
      }
    }
    _appIcon = _sliderValue > 95 ? icons[icons.length - 1] : icons[((_sliderValue / 100) * (icons.length - 2)).round()];
  }

  Row createRow(String key, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(padding: const EdgeInsets.only(left: 8.0), height: 50, color: Colors.grey[200], child: Align(alignment: Alignment.centerLeft, child: Text(key))),
        ),
        Expanded(
          flex: 1,
          child: Container(padding: const EdgeInsets.only(left: 8.0), height: 50, color: Colors.grey[300], child: Align(alignment: Alignment.centerLeft, child: Text(value))),
        ),
      ],
    );
  }

  Row createWidgetRow(Widget child) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(padding: const EdgeInsets.only(left: 8.0), color: Colors.grey[200], child: child),
        ),
      ],
    );
  }

  static Color getHeatColor(double percentage, List<Color> colors) {
    var startIndex = (percentage * (colors.length - 1)).floor();
    var endIndex = (percentage * (colors.length - 1)).ceil();
    var time = (percentage * (colors.length - 1)) - startIndex;
    return Color.lerp(colors[startIndex], colors[endIndex], time) ?? colors[0];
  }

  static void _createCpuLoad(Duration pause) async {
    while (true) {
      if (DateTime.now().millisecondsSinceEpoch % 100 == 0) {
        await Future.delayed(pause);
      }
    }
  }
}
