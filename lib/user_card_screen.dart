import 'package:cards/user.dart';
import 'package:flutter/material.dart';
import 'package:cards/user_service.dart';

class UserCardScreen extends StatefulWidget {
  const UserCardScreen({super.key});

  @override
  _UserCardScreenState createState() => _UserCardScreenState();
}

class _UserCardScreenState extends State<UserCardScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = UserService().fetchAndStoreUsers() as Future<List<User>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 140, 243),
        title: const Text('User Cards'),
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('ID: ${user.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('First Name: ${user.firstName}'),
                        Text('Last Name: ${user.lastName}'),
                        Text('Maiden Name: ${user.maidenName}'),
                        Text('Age: ${user.age}'),
                        Text('Gender: ${user.gender}'),
                        Text('Email: ${user.email}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}