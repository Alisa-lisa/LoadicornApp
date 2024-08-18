import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loadiapp/widgets/accounts/account_dialog.dart';
import 'package:loadiapp/widgets/tags/tag_dialog.dart';
import 'package:loadiapp/widgets/transactions/transaction_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Loadicorn'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
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
                          return const AccountDialog();
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
                          return const TagDialog();
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
                          return const TransactionDialog();
                        });
                  }),

	    ]
	    )
          );
  }
}
