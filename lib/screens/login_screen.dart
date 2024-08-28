import 'package:flutter/material.dart';
import '../db_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await _dbHelper.getUser(username);
    if (user == null) {
      await _dbHelper.insertUser(username, password);
      _showMessage('User registered successfully!');
    } else {
      _showMessage('User already exists.');
    }
  }
  Future<void> _loginUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await _dbHelper.getUser(username);
    if (user != null && user['password'] == password) {
      _showMessage('Login successful!');
      // Navigate to the next screen here
    } else {
      _showMessage('Invalid username or password.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: _registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
