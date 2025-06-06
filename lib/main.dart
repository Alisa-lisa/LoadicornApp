import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loadiapp/const.dart';
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

String getToday(DateTime date) {
  String month =
      date.month < 10 ? format("0{}", date.month) : date.month.toString();
  return format("{}-{}-01", date.year, month);
}

bool anyDataPresent(List<Map<String, List<String>>> input, DateTime date) {
  String thisMonth = getToday(date);
  for (var item in input) {
    if (item.keys.first == thisMonth) {
      return true;
    }
  }
  return false;
}

class _MyHomePageState extends State<MyHomePage> {
  CustomCache get cache => widget.cache;
  final ScrollController _scroll = ScrollController();

  double getTotalMonth() {
    DateTime now = DateTime.now();
    String today = getToday(now);
    bool haveData = anyDataPresent(cache.state['monthlyTrend'], now);
    double total = haveData
        ? -double.parse(cache.state["monthlyTrend"].last[today][0])
        : 0.0;
    double reoccur = !cache.state['reoccur'].isEmpty
        ? cache.state['reoccur'].values.reduce((double a, double b) => a + b)
        : 0.0;
    return total < reoccur ? 0.0 : total - reoccur;
  }

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
        body: CustomScrollView(
          controller: _scroll,
          slivers: [
            const SliverPadding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
            SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                          format("Re-occuring expenses {}-{}", today.year,
                              today.month),
                          style: style)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: height * 0.2, maxWidth: width * 0.95),
                          child: getReoccuring(cache.state['reoccur'])))
                ])),
            const SliverPadding(padding: EdgeInsets.fromLTRB(0, 10, 0, 5)),
            if (!cache.state['special'].isEmpty)
              SliverToBoxAdapter(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text(
                            format("Special expenses {}-{}", today.year,
                                today.month),
                            style: style)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: height * 0.2,
                                maxWidth: width * 0.95),
                            child: getReoccuring(cache.state['special'])))
                  ])),
            SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                          format("Cost structure for {}-{}. Total: {}",
                              today.year, today.month, getTotalMonth()),
                          style: style)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                          width: width * 0.95,
                          height: height * 0.3,
                          child: prepareMonthlyStructureBar(
                              cache.state['monthlyStructure'],
                              cache.state['tags'])))
                ])),
            const SliverPadding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
            SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text("Monthly trend", style: style)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SizedBox(
                            width: width * 0.95,
                            height: height * 0.3,
                            child: prepareTotalTrendBar(
                                cache.state["monthlyTrend"]))),
                  ]),
            )
          ],
        ),
        // SingleChildScrollView(
        //     child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        // if (specialPresent == true){
        //   return Column(children: [
        //   Padding(
        //       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        //       child: Text(
        //           format("Special expenses {}-{}", today.year, today.month),
        //           style: style)),
        // Padding(
        //     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        //     child: SizedBox(
        //         width: width * 0.95,
        //         height: height * 0.2,
        //         child: getReoccuring(cache.state['special']))),
        //   ]);},
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
