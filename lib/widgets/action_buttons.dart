import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: _buildButton('Buy')),
            Expanded(child: _buildButton('Sell')),
          ],
        ),
        _buildButton('Recycle', double.infinity),
        ElevatedButton(
          onPressed: () {
            print("Button Pressed!");
          },
          child: const Text('data'),
        ),
      ],
    );
  }

  Widget _buildButton(String text, [double? wid]) {
    return Container(
      height: 70,
      width: wid, // No need for width in Expanded
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
