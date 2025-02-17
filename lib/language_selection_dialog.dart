import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 400,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _languageButton("🇰🇷", "한국어"),
                    _languageButton("🇯🇵", "일본어"),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _languageButton("🇨🇳", "중국어"),
                    _languageButton("🇺🇸", "영어"),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageButton(String flag, String language) {
    return Column(
      children: [
        Text(flag, style: TextStyle(fontSize: 50)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => print("$language 선택됨"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(language, style: TextStyle(fontSize: 25, color: Colors.black)),
        ),
      ],
    );
  }
}