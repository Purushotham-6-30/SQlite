
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cards/user.dart';
import 'package:cards/dbhelper.dart';

class UserService {
  static const String apiUrl = "https://dummyjson.com/users";
  final DBHelper dbHelper = DBHelper();

  Future<List<User>> fetchAndStoreUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<User> users = (data['users'] as List)
            .map((user) => User.fromJson(user))
            .toList();

        
        await dbHelper.clearUsers();

        for (var user in users) {
          await dbHelper.insertUser(user);
        }

        
        return users;
      } else {
        throw Exception('Failed to fetch users from API');
      }
    } catch (e) {
      
      final usersFromDB = await dbHelper.getUsers();
      if (usersFromDB.isNotEmpty) {
        return usersFromDB; 
      }
      rethrow; 
    }
  }
}