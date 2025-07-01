import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/controllers/tags.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/local_storage.dart';
import 'package:loadiapp/const.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/login.dart';
import 'package:loadiapp/widgets/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  CustomCache cache = CustomCache();

  String? id = await Storage.getStr("id");
  cache.add({"id": id});
  if (id != null) {
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
    cache.updateSimple("id", id);
    cache.add({"accounts": accs});
    cache.add({"tags": tags});
    cache.add({"total": total});
    cache.add({"monthlyTrend": monthlyTrend});
    cache.add({"monthlyStructure": monthlyStructure});
    cache.add({"reoccur": monthlyReoccur});
    cache.add({"special": monthlySpecial});
  }
  runApp(MyApp(cache: cache));
}

class MyApp extends StatelessWidget {
  final CustomCache cache;

  const MyApp({required this.cache, super.key});

  @override
  Widget build(BuildContext context) {
    if (cache.state["id"] == null) {
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
        home: MyHomePage(cache: cache),
      );
    }
  }
}
