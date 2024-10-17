import 'package:flutter/material.dart';
import 'package:flutter042/models/user_model.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_service.dart';
import 'providers/user_provider.dart';
import 'package:flutter042/pages/admin/adminPage.dart';
import 'package:flutter042/pages/user/userPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController =
      TextEditingController(text: "652021042");
  final TextEditingController passwordController =
      TextEditingController(text: "652021042");

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;
      print('UserID: $username, Password: $password');

      try {
        final result = await AuthService().login(username, password);

        if (result['success']) {
          UserModel authResponse = result['message'];

          if (!mounted) return;
          Provider.of<UserProvider>(context, listen: false)
              .onLogin(authResponse);

          print('Login successful. Welcome, ${authResponse.user.firstname} ${authResponse.user.lastname}');
          print('Access Token: ${authResponse.accessToken}');
          print('Refresh Token: ${authResponse.refreshToken}');
          print('Role: ${authResponse.role}');

          if (authResponse.role == "admin") {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
              (route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
              (route) => false,
            );
          }

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed. Please try again.')),
          );
        }
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
      ),
      body: Center( // Center the form on the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the Column contents
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'UserID',
                   labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.indigo[700]),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[700],
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.pink[30],
    );
  }
}
