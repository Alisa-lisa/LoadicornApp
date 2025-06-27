import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loadiapp/const.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/login.dart';
import 'package:loadiapp/widgets/home.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/tags.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  List<Account> accs = await fetchAccounts();
  List<Tag> tags = await fetchTags();
  String total = await getTotal();
  List<Map<String, List<String>>> monthlyTrend =
      await collectMonthlyTrend(trendMonths);
  Map<String, double> monthlyStructure = await collectMontlyStructure();
  DateTime now = DateTime.now();
  Map<String, double> monthlyReoccur = await collectReoccuring(now, "REPEAT");
  Map<String, double> monthlySpecial = await collectReoccuring(now, "SPECIAL");
  CustomCache cache = CustomCache();
  cache.add({"user": null});
  cache.add({"accounts": accs});
  cache.add({"tags": tags});
  cache.add({"total": total});
  cache.add({"monthlyTrend": monthlyTrend});
  cache.add({"monthlyStructure": monthlyStructure});
  cache.add({"reoccur": monthlyReoccur});
  cache.add({"special": monthlySpecial});
  runApp(MyApp(cache: cache));
}

class MyApp extends StatelessWidget {
  final CustomCache cache;

  const MyApp({required this.cache, super.key});

  @override
  Widget build(BuildContext context) {
    if (cache.state["user"] == null) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginPage(cache: cache),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Loadicorn', cache: cache),
      );
    }
  }
}
