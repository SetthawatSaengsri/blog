// login.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_page.dart';
import 'blog_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เข้าสู่ระบบ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(controller: _usernameController, label: "ชื่อผู้ใช้งาน"),
            SizedBox(height: 20),
            _buildTextField(controller: _passwordController, label: "รหัสผ่าน", obscureText: true),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              child: Text("เข้าสู่ระบบ"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text("ยังไม่มีบัญชี? สมัครสมาชิก"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      obscureText: obscureText,
    );
  }

  _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String adminUsername = "admin";
    String adminPassword = "1234";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedUsername = prefs.getString('username') ?? '';
    String storedPassword = prefs.getString('password') ?? '';

    String role = (username == adminUsername && password == adminPassword) ? "admin" : "user";

    if (username == storedUsername && password == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BlogPage(role: role, username: username)),
      );
    } else if (username == adminUsername && password == adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BlogPage(role: "admin", username: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง"),
      ));
    }
  }
}
