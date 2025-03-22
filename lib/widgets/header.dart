import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.blue,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Exonova',
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
          Row(
            children: [
              Image.network(
                'https://cdn0.iconfinder.com/data/icons/cryptocurrency-137/128/1_profile_user_avatar_account_person-132-1024.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 15),
              Image.network(
                'https://cdn4.iconfinder.com/data/icons/wirecons-free-vector-icons/32/menu-alt-1024.png',
                height: 30,
                width: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
