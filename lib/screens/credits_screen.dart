import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  CreditsScreen({super.key});

  // Mock data - in a real app, you would fetch this from your backend
  final int totalCredits = 350;
  final List<Map<String, dynamic>> recentCredits = [
    {
      'date': '15 Mar 2025',
      'type': 'laptop',
      'weight': '2.5 kg',
      'credits': 25,
      'icon': Icons.restore_from_trash,
      'color': Colors.green,
    },
    {
      'date': '10 Mar 2025',
      'type': 'Printer',
      'weight': '5 kg',
      'credits': 50,
      'icon': Icons.description,
      'color': Colors.green,
    },
    {
      'date': '05 Mar 2025',
      'type': 'Television',
      'weight': '4 kg',
      'credits': 80,
      'icon': Icons.grade,
      'color': Colors.amber,
    },
    {
      'date': '28 Feb 2025',
      'type': 'Batteries',
      'weight': '1.5 kg',
      'credits': 45,
      'icon': Icons.watch,
      'color': Colors.grey,
    },
  ];

  final List<Map<String, dynamic>> availableRewards = [
    {
      'name': 'Eco-friendly Tote Bag',
      'credits': 100,
      'discount': '50% off',
      'image': Icons.shopping_bag,
      'color': Colors.teal,
    },
    {
      'name': 'Reusable Water Bottle',
      'credits': 150,
      'discount': '30% off',
      'image': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'name': 'Bamboo Cutlery Set',
      'credits': 200,
      'discount': '40% off',
      'image': Icons.restaurant,
      'color': Colors.brown,
    },
    {
      'name': 'Eco-friendly Tote Bag',
      'credits': 100,
      'discount': '50% off',
      'image': Icons.shopping_bag,
      'color': Colors.teal,
    },
    {
      'name': 'Reusable Water Bottle',
      'credits': 150,
      'discount': '30% off',
      'image': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'name': 'Bamboo Cutlery Set',
      'credits': 200,
      'discount': '40% off',
      'image': Icons.restaurant,
      'color': Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recycling Credits",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreditSummary(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Recent Credits Earned",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildRecentCreditsList(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Available Rewards",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildAvailableRewards(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Your Recycling Credits",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, color: Colors.white, size: 32),
              const SizedBox(width: 8),
              Text(
                "$totalCredits",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Redeem Credits"),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCreditsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentCredits.length,
      itemBuilder: (context, index) {
        final credit = recentCredits[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: credit['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(credit['icon'], color: credit['color']),
            ),
            title: Text(
              "${credit['type']} - ${credit['weight']}",
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              credit['date'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "+${credit['credits']}",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvailableRewards() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableRewards.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final reward = availableRewards[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: reward['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    reward['image'],
                    color: reward['color'],
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    reward['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${reward['discount']} for ${reward['credits']} credits",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(100, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text("Redeem", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
