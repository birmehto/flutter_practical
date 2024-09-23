import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? selectedColor = 'green';
  double sliderValue = 0.0;
  Color currentColor = Colors.greenAccent;

  TextEditingController totalItemController = TextEditingController();
  TextEditingController itemListController = TextEditingController();

  bool isSelected = false;
  double progressValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startProgress() {
    Duration duration;
    if (sliderValue == 0.0) {
      duration = const Duration(milliseconds: 40);
    } else if (sliderValue == 1.0) {
      duration = const Duration(milliseconds: 20);
    } else {
      duration = const Duration(milliseconds: 10);
    }

    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (isSelected) {
          progressValue -= 0.01;
          if (progressValue <= 0.0) {
            progressValue = 1.0;
          }
        } else {
          progressValue += 0.01;
          if (progressValue >= 1.0) {
            progressValue = 0.0;
          }
        }
      });
    });
  }

  void updateProgressSpeed(double value) {
    setState(() {
      sliderValue = value;
      _timer?.cancel();
      startProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> colorList = ['green', 'red', 'blue', 'purple'];
    Map<String, Color> colorMap = {
      'green': Colors.greenAccent,
      'red': Colors.red,
      'blue': Colors.blue,
      'purple': Colors.purple,
    };

    Color selectedColors = colorMap[selectedColor!]!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const FlutterLogo(
              size: 100,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          isExpanded: true,
                          value: selectedColor,
                          items: colorList.map((String color) {
                            return DropdownMenuItem<String>(
                              value: color,
                              child: Text(color),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedColor = newValue;
                              currentColor = colorMap[newValue!]!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: sliderValue,
                    min: 0.0,
                    max: 2.0,
                    divisions: 2,
                    label: sliderValue == 0.0
                        ? 'Slow'
                        : sliderValue == 1.0
                            ? 'Smooth'
                            : 'Fast',
                    activeColor: selectedColors,
                    inactiveColor: selectedColors.withOpacity(0.5),
                    onChanged: (double value) {
                      updateProgressSpeed(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: totalItemController,
                    cursorColor: selectedColors,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text('Total Item'),
                      labelStyle: TextStyle(color: selectedColors),
                      border: _outlinStyle(context),
                      enabledBorder: _outlinStyle(context),
                      focusedBorder: _outlinStyle(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: itemListController,
                    cursorColor: selectedColors,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    decoration: InputDecoration(
                      label: const Text('Items In line'),
                      labelStyle: TextStyle(color: selectedColors),
                      border: _outlinStyle(context),
                      enabledBorder: _outlinStyle(context),
                      focusedBorder: _outlinStyle(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reverse',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: currentColor),
                      ),
                      Switch(
                        value: isSelected,
                        activeColor: currentColor,
                        onChanged: (bool value) {
                          setState(() {
                            isSelected = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: int.tryParse(totalItemController.text) ?? 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            int.tryParse(itemListController.text) ?? 1,
                        childAspectRatio: 20.0,
                        mainAxisSpacing: 2.0,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progressValue,
                              color: isSelected ? Colors.white : currentColor,
                              backgroundColor:
                                  isSelected ? currentColor : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _outlinStyle(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: currentColor),
    );
  }
}
