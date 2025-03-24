import 'package:flutter/material.dart';
import 'package:Econova/main.dart';
import 'create_group_screen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Flutter Developers',
      'members': 128,
      'image': 'assets/flutter.png',
      'isCreator': false,
      'isJoined': false,
    },
    {
      'name': 'UI/UX Design',
      'members': 85,
      'image': 'assets/design.png',
      'isCreator': true,
      'isJoined': true,
    },
    {
      'name': 'Mobile App Testing',
      'members': 64,
      'image': 'assets/testing.png',
      'isCreator': false,
      'isJoined': true,
    },
  ];

  void _addGroup(Map<String, dynamic> newGroup) {
    // Add creator and joined status to new group
    newGroup['isCreator'] = true;
    newGroup['isJoined'] = true;

    setState(() {
      _groups.add(newGroup);
    });
  }

  void _deleteGroup(String groupName) {
    setState(() {
      _groups.removeWhere((group) => group['name'] == groupName);
    });
  }

  void _toggleJoinGroup(Map<String, dynamic> group) {
    setState(() {
      group['isJoined'] = !group['isJoined'];
      // If joining, increment members count
      if (group['isJoined']) {
        group['members']++;
      } else {
        // If leaving, decrement members count
        group['members']--;
      }
    });
  }

  void _openGroupDetails(BuildContext context, Map<String, dynamic> group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text(group['name']),
                backgroundColor: Colors.blue,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GroupsScreen(),
                      ),
                    );
                  },
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      group['image'],
                      width: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.group,
                          size: 100,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Members: ${group['members']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    if (group['isCreator'])
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Group'),
                        onPressed: () {
                          // Implement edit functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit functionality to be implemented',
                              ),
                            ),
                          );
                        },
                      ),
                    if (!group['isCreator'])
                      ElevatedButton.icon(
                        icon: Icon(
                          group['isJoined']
                              ? Icons.exit_to_app
                              : Icons.person_add,
                        ),
                        label: Text(
                          group['isJoined'] ? 'Leave Group' : 'Join Group',
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _toggleJoinGroup(group);
                        },
                      ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainAppScreen()),
            );
          },
        ),
        title: const Text(
          'My Groups',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            _buildCategoryHeader(context, 'My Groups'),
            const SizedBox(height: 16),
            ..._groups
                .where((group) => group['isJoined'])
                .map((group) => _buildGroupCard(context, group)),
            const SizedBox(height: 24),
            _buildCategoryHeader(context, 'Discover Groups'),
            const SizedBox(height: 16),
            ..._groups
                .where((group) => !group['isJoined'])
                .map((group) => _buildGroupCard(context, group)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newGroup = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
          );

          if (newGroup != null) {
            _addGroup(newGroup);
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Create Group',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, Map<String, dynamic> group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 24,
          child: Icon(
            Icons.group,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          group['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${group['members']} members',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // View button
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              tooltip: 'View Details',
              onPressed: () {
                _openGroupDetails(context, group);
              },
            ),
            // Join/Leave button
            if (!group['isCreator'])
              IconButton(
                icon: Icon(
                  group['isJoined'] ? Icons.person_remove : Icons.person_add,
                  color: group['isJoined'] ? Colors.blue : Colors.orange,
                ),
                tooltip: group['isJoined'] ? 'Leave Group' : 'Join Group',
                onPressed: () {
                  _toggleJoinGroup(group);
                },
              ),
            // Delete button (only for groups created by the user)
            if (group['isCreator'])
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Delete Group',
                onPressed: () {
                  _deleteGroup(group['name']);
                },
              ),
          ],
        ),
        onTap: () {
          _openGroupDetails(context, group);
        },
      ),
    );
  }
}
