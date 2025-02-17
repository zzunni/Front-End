import 'package:flutter/material.dart';

class InterpretationDialog {
  static Widget build(BuildContext context) {  // ← static 추가
    double difficulty = 0.0;
    double gender = 0.0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 350,
            height: 400,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 20),
                _buildCustomSlider(
                  labels: ["쉬움", "어려움"],
                  value: difficulty,
                  divisions: 2,
                  onChanged: (newValue) => setState(() => difficulty = newValue),
                ),
                SizedBox(height: 50),
                _buildCustomSlider(
                  labels: ["남자", "여자"],
                  value: gender,
                  divisions: 1,
                  onChanged: (newValue) => setState(() => gender = newValue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildCustomSlider({  // ← 이미 static이므로 문제 없음
    required List<String> labels,
    required double value,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            return Text(
              labels[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SliderTheme(
              data: SliderThemeData(
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                trackHeight: 2,
              ),
              child: Slider(
                value: value,
                min: 0,
                max: divisions.toDouble(),
                divisions: divisions,
                activeColor: Colors.transparent,
                inactiveColor: Colors.white,
                onChanged: onChanged,
              ),
            ),
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(divisions + 1, (index) {
                  bool isSelected = (value == index.toDouble());
                  return Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 2),
                      color: isSelected ? Colors.orange : Colors.black,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
