import 'package:loadiapp/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:loadiapp/controllers/user.dart';
import 'package:loadiapp/widgets/home.dart';
import 'package:loadiapp/const.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/controllers/tags.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';

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

  bool obscureText = true;

  Future<void> _register() async {
    try {
      String id = await registerUser(
          _usernameController.text, _passwordController.text);
      setState(() {
        cache.updateSimple("id", id);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                LoginPage(cache: cache))); // Navigate to HomeScree
      });
    } catch (e) {
      throw Exception("Could not register a user due to {e}");
    }
  }

  Future<void> _login() async {
    try {
      String id =
          await logIn(_usernameController.text, _passwordController.text);
      List<Account> accs = await fetchAccounts(id);
      List<Tag> tags = await fetchTags(id);
      String total = await getTotal(id);
      List<Map<String, List<String>>> monthlyTrend =
          await collectMonthlyTrend(id, trendMonths);
      Map<String, double> monthlyStructure = await collectMontlyStructure(id);
      DateTime now = DateTime.now();
      Map<String, double> monthlyReoccur =
          await collectReoccuring(id, now, "REPEAT");
      Map<String, double> monthlySpecial =
          await collectReoccuring(id, now, "SPECIAL");
      setState(() {
        cache.updateSimple("id", id);
        cache.add({"accounts": accs});
        cache.add({"tags": tags});
        cache.add({"total": total});
        cache.add({"monthlyTrend": monthlyTrend});
        cache.add({"monthlyStructure": monthlyStructure});
        cache.add({"reoccur": monthlyReoccur});
        cache.add({"special": monthlySpecial});
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyHomePage(
                title: "Loadicorn", cache: cache))); // Navigate to HomeScree
      });
    } catch (e) {
      throw Exception("Username and password are incorrect due to {e}");
    }
  }

  Icon getVisibility(bool isVisible) {
    if (isVisible == true) {
      return const Icon(Icons.visibility);
    } else {
      return const Icon(Icons.visibility_off);
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
                obscureText: obscureText, // Hide password characters
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: getVisibility(obscureText),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
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
                  onPressed: _register,
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
