import 'package:loadiapp/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:loadiapp/controllers/user.dart';
import 'package:loadiapp/widgets/home.dart';

class LoginPage extends StatefulWidget {
  final CustomCache cache;
  const LoginPage({super.key, required this.cache});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CustomCache get cache => widget.cache;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoggingIn = false; // flag to indicate login state.
  String _loginResult = ''; //To store message result of login

  Future<void> _login() async {
    try {
      String id =
          await logIn(_usernameController.text, _passwordController.text);
      setState(() {
        cache.update("id", id);
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHomePage(
              title: "Loadicorn", cache: cache))); // Navigate to HomeScree
    } catch (e) {
      throw Exception("Username and password are incorrect");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Password Form
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true, // Hide password characters
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordController.isObscured =
                            !_passwordController.isObscured;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Login Button
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Distribute evenly
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
