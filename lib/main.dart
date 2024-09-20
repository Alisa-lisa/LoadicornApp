import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/accounts/account_dialog.dart';
import 'package:loadiapp/widgets/tags/tag_dialog.dart';
import 'package:loadiapp/widgets/transactions/transaction_dialog.dart';
import 'package:loadiapp/widgets/analytics.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/controllers/tags.dart';

const style = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 12,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Account> accs = await fetchAccounts();
  List<Tag> tags = await fetchTags();
  String total = await getTotal();
  List<Map<String, List<String>>> totalTrend = await collectTotalTrend();
  Map<String, double> monthlyStructure = await collectMontlyStructure();
  CustomCache cache = CustomCache();
  cache.add({"accounts": accs});
  cache.add({"tags": tags});
  cache.add({"total": total});
  cache.add({"totalTrend": totalTrend});
  cache.add({"monthlyStructure": monthlyStructure});
  runApp(MyApp(cache: cache));
}

class MyApp extends StatelessWidget {
  final CustomCache cache;

  const MyApp({required this.cache, super.key});

  @override
  Widget build(BuildContext context) {
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

class MyHomePage extends StatefulWidget {
  final CustomCache cache;
  final String title;
  const MyHomePage({super.key, required this.title, required this.cache});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CustomCache get cache => widget.cache;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    DateTime today = DateTime.now();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(cache.state['total'], style: style))
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(format("Cost structure for {}-{}", today.year, today.month),
                style: style),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SizedBox(
                    width: width * 0.95,
                    height: height * 0.3,
                    child: prepareMonthlyStructureBar(
                        cache.state['monthlyStructure']))),
            const Text("Monthly trend", style: style),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SizedBox(
                    width: width * 0.95,
                    height: height * 0.3,
                    child: prepareTotalTrendBar(cache.state["totalTrend"]))),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: SpeedDial(
            icon: Icons.add_outlined,
            backgroundColor: Colors.lightBlue.shade100,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.credit_card),
                  label: 'Account',
                  backgroundColor: Colors.lightBlue.shade100,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AccountDialog(cache: cache);
                        }).then((_) {
                      setState(() {});
                    });
                  }),
              SpeedDialChild(
                  child: const Icon(Icons.construction),
                  label: 'Tag',
                  backgroundColor: Colors.lightBlue.shade300,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return TagDialog(cache: cache);
                        }).then((_) {
                      setState(() {});
                    });
                  }),
              SpeedDialChild(
                  child: const Icon(Icons.attach_money),
                  label: 'Transaction',
                  backgroundColor: Colors.lightBlue.shade500,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return TransactionDialog(cache: cache);
                        }).then((_) {
                      setState(() {});
                    });
                  }),
            ]));
  }
}
