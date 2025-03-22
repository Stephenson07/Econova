import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';

class EWasteDashboard extends StatefulWidget {
  const EWasteDashboard({super.key});

  @override
  State<EWasteDashboard> createState() => _EWasteDashboardState();
}

class _EWasteDashboardState extends State<EWasteDashboard> {
  // Sample data
  final Map<String, double> recycledWasteData = {
    'Smartphones': 2.5,
    'Laptops': 4.8,
    'Monitors': 3.2,
    'Printers': 1.7,
    'Batteries': 0.9,
  };

  final List<Map<String, dynamic>> monthlyData = [
    {'month': 'Jan', 'weight': 3.2},
    {'month': 'Feb', 'weight': 2.8},
    {'month': 'Mar', 'weight': 5.1},
    {'month': 'Apr', 'weight': 3.9},
    {'month': 'May', 'weight': 4.2},
    {'month': 'Jun', 'weight': 6.0},
  ];

  // Environmental impact data
  final Map<String, dynamic> environmentalImpact = {
    'Co2Reduced': 235.8, // kg
    'WaterSaved': 1850.0, // liters
    'EnergyConserved': 420.5, // kWh
    'TreesEquivalent': 12,
  };

  // Recycling stats
  final double totalRecycled = 13.1; // kg
  final int totalItems = 28;
  final double monthlyAverage = 3.8; // kg

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Waste Management',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        // actions: [
        //   IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        //   IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              // const Text(
              //   'Hello, Sarah!',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              // Text(
              //   'Your recycling journey for ${DateFormat('MMMM yyyy').format(DateTime.now())}',
              //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              // ),
              const SizedBox(height: 24),

              // Summary cards
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSummaryCard(
                    'Total Recycled',
                    '$totalRecycled kg',
                    Icons.delete_outline,
                    Colors.blue,
                  ),
                  _buildSummaryCard(
                    'Items Recycled',
                    '$totalItems items',
                    Icons.devices,
                    Colors.blue,
                  ),
                  _buildSummaryCard(
                    'CO₂ Reduced',
                    '${environmentalImpact['Co2Reduced']} kg',
                    Icons.eco,
                    Colors.teal,
                  ),
                  _buildSummaryCard(
                    'Trees Saved',
                    '${environmentalImpact['TreesEquivalent']} trees',
                    Icons.park,
                    Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Monthly recycling progress
              const Text(
                'Monthly Recycling Progress',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 7,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        // tooltipBgColor: Colors.blue,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${monthlyData[groupIndex]['month']}: ${rod.toY.toStringAsFixed(1)} kg',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value >= monthlyData.length) {
                              return const Text('');
                            }
                            return Text(monthlyData[value.toInt()]['month']);
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) {
                              return const Text('0');
                            }
                            if (value % 2 == 0) {
                              return Text('${value.toInt()} kg');
                            }
                            return const Text('');
                          },
                          reservedSize: 40,
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(
                      monthlyData.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: monthlyData[index]['weight'],
                            color: Colors.blueAccent,
                            width: 22,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recycling breakdown
              const Text(
                'Recycling Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: _getPieSections(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            recycledWasteData.entries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: _getColorForCategory(
                                              entry.key,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          entry.key,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Environmental impact
              const Text(
                'Your Environmental Impact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildImpactRow(
                        'Water Saved',
                        '${environmentalImpact['WaterSaved']} liters',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                      const Divider(),
                      _buildImpactRow(
                        'Energy Conserved',
                        '${environmentalImpact['EnergyConserved']} kWh',
                        Icons.bolt,
                        Colors.amber,
                      ),
                      const Divider(),
                      _buildImpactRow(
                        'CO₂ Emissions Reduced',
                        '${environmentalImpact['Co2Reduced']} kg',
                        Icons.cloud,
                        Colors.teal,
                      ),
                      const Divider(),
                      _buildImpactRow(
                        'Equivalent to Trees Planted',
                        '${environmentalImpact['TreesEquivalent']} trees',
                        Icons.forest,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Achievement badges
              const Text(
                'Your Achievements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildAchievementBadge(
                      'First Recycler',
                      Icons.star,
                      Colors.amber,
                    ),
                    _buildAchievementBadge(
                      'Earth Saver',
                      Icons.public,
                      Colors.blue,
                    ),
                    _buildAchievementBadge(
                      'Tech Hero',
                      Icons.computer,
                      Colors.blue,
                    ),
                    _buildAchievementBadge(
                      '10kg Club',
                      Icons.verified,
                      Colors.purple,
                    ),
                    _buildAchievementBadge(
                      'Consistent Recycler',
                      Icons.repeat,
                      Colors.teal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recycling tips
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Recycling Tip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Did you know? Recycling one million laptops saves enough energy to power 3,657 homes for a year!',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('More Tips'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       label: 'Dashboard',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.recycling),
      //       label: 'Recycle',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Centers'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Add new recycling item',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieSections() {
    return recycledWasteData.entries.map((entry) {
      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: '${(entry.value / totalRecycled * 100).toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getColorForCategory(String category) {
    final colors = {
      'Smartphones': Colors.blue,
      'Laptops': Colors.red,
      'Monitors': Colors.blue,
      'Printers': Colors.purple,
      'Batteries': Colors.orange,
    };
    return colors[category] ?? Colors.grey;
  }

  Widget _buildImpactRow(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class EWasteDashboard extends StatelessWidget {
//   const EWasteDashboard({super.key});

//   Widget _buildDrawerItem(
//     BuildContext context,
//     IconData icon,
//     String title,
//     Widget screen,
//   ) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap:
//           () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => screen),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('E-Waste Management Dashboard')),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             _buildDrawerItem(
//               context,
//               Icons.settings,
//               'Settings',
//               const SettingsScreen(),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'E-Waste Metrics Overview',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(show: true),
//                   borderData: FlBorderData(show: true),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         const FlSpot(0, 1),
//                         const FlSpot(1, 3),
//                         const FlSpot(2, 2),
//                         const FlSpot(3, 4),
//                       ],
//                       isCurved: true,
//                       color: Colors.blue,
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Recycled Items: 120 Kg',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//             const Text(
//               'E-Waste Collected: 320 Kg',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: const Center(child: Text('Settings Screen Content')),
//     );
//   }
// }
