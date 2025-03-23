import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildRowOfButtons(), _buildFullWidthButton('Recycle')],
    );
  }

  // Creates a row with Buy and Sell buttons
  Widget _buildRowOfButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildButton('Buy'), _buildButton('Sell')],
    );
  }

  // Creates a button that takes full width
  Widget _buildFullWidthButton(String text) {
    return _buildButton(text, double.infinity);
  }

  // Reusable method to build buttons with customizable text and width
  Widget _buildButton(String text, [double? width]) {
    return Container(
      height: 70,
      width: width ?? double.infinity, // Default to full width if not provided
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
