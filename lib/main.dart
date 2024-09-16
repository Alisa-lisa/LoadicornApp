import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loadiapp/models/account.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/accounts/account_dialog.dart';
import 'package:loadiapp/widgets/tags/tag_dialog.dart';
import 'package:loadiapp/widgets/transactions/transaction_dialog.dart';
import 'package:loadiapp/controllers/state.dart';
import 'package:loadiapp/controllers/accounts.dart';
import 'package:loadiapp/controllers/analytics.dart';
import 'package:loadiapp/controllers/tags.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Account> accs = await fetchAccounts();
  List<Tag> tags = await fetchTags();
  String total = await getTotal();
  CustomCache cache = CustomCache();
  cache.add({"accounts": accs});
  cache.add({"tags": tags});
  cache.add({"total": total});
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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: <Widget>[Text(cache.state['total'])]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Here last 5 transactions would be shown',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
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
