import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// TBD add colors/icons to DBs
Map<String, Color> accountsColors = {
  "haspa work": Colors.lightBlue[100]!,
  "default cash": Colors.teal[100]!,
  "revolut": Colors.blueGrey[200]!,
  "vivid": Colors.lightBlue,
  "dkb personal": Colors.deepPurple[600]!,
  "dkb invest": Colors.blueGrey[400]!,
  "dkb shared": Colors.blueGrey[800]!,
  "revolut private": Colors.indigo[700]!,
  "haspa private": Colors.purple[800]!
};

Map<String, Color> tg = {
  "groceries": Colors.green[600]!,
  "eatOut": Colors.amber[600]!,
  "present": Colors.purpleAccent[400]!,
  "home": Colors.indigo[300]!,
  "transport": Colors.cyanAccent[700]!,
  "health": Colors.red[600]!,
  "hobby": Colors.green[300]!,
  "selfDev": Colors.green[100]!,
  "selfCare": Colors.lightBlueAccent[700]!,
  "vacation": Colors.pinkAccent,
  "sport": Colors.cyanAccent,
  "fun": Colors.lightGreenAccent,
  "social": Colors.cyan[800]!,
  "clothes": Colors.deepPurple[200]!,
  "charity": Colors.blueGrey[200]!,
  "service": Colors.brown[100]!,
  "insurance": Colors.deepPurple[700]!,
  "None": Colors.purple[300]!
};

Map<String, int> tagsBar = {
  "groceries": 1,
  "eatOut": 2,
  "present": 3,
  "home": 4,
  "transport": 5,
  "health": 6,
  "hobby": 7,
  "selfDev": 8,
  "selfCare": 9,
  "vacation": 10,
  "sport": 11,
  "fun": 12,
  "social": 13,
  "clothes": 14,
  "charity": 15,
  "service": 16,
  "insurance": 17,
  "None": 18
};

const style = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 8,
);

Widget getMonthlyLabel(double value) {
  Widget text;
  switch ((value.toInt())) {
    case 1:
      text = const Text('Jan', style: style);
      break;
    case 2:
      text = const Text('Feb', style: style);
      break;
    case 3:
      text = const Text('Mar', style: style);
      break;
    case 4:
      text = const Text('Apr', style: style);
      break;
    case 5:
      text = const Text('May', style: style);
      break;
    case 6:
      text = const Text('Jun', style: style);
      break;
    case 7:
      text = const Text('Jul', style: style);
      break;
    case 8:
      text = const Text('Aug', style: style);
      break;
    case 9:
      text = const Text('Sep', style: style);
      break;
    case 10:
      text = const Text('Oct', style: style);
      break;
    case 11:
      text = const Text('Nov', style: style);
      break;
    case 12:
      text = const Text('Dec', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }
  return text;
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  return Text(value.toString(), style: style, textAlign: TextAlign.center);
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  return SideTitleWidget(
    meta: meta,
    child: getMonthlyLabel(value),
  );
}

List<LineChartBarData> getTotalTrendData(Map<String, Decimal> trend) {
  List<FlSpot> points = [];
  for (var timeItem in trend.entries) {
    double x = DateTime.parse(timeItem.key).month.toDouble();
    points.add(FlSpot(x, -timeItem.value.toDouble()));
  }
  return [
    LineChartBarData(
      spots: points,
      isCurved: false,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
    ),
  ];
}

LineChart prepareTotalTrend(Map<String, Decimal> trend) {
  return LineChart(LineChartData(
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minY: 0,
      maxY: 6000,
      lineBarsData: getTotalTrendData(trend)));
}

List<BarChartGroupData> _buildBarGroups(List<Map<String, List<String>>> data) {
  return List.generate(data.length, (index) {
    final dateValueMap = data[index];
    final values = dateValueMap.values.first;

    return BarChartGroupData(
        x: index, // Use index as the X-axis value
        barRods: [
          BarChartRodData(
            toY: -double.parse(values[0]),
            color: Colors.red,
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: double.parse(values[1]),
            color: Colors.green,
            width: 10,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [
          0,
          // 1
        ]);
  });
}

BarChart prepareTotalTrendBar(List<Map<String, List<String>>> trend) {
  return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      barGroups: _buildBarGroups(trend),
      minY: 0,
      maxY: 8000,
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                DateTime date = DateTime.parse(trend[value.toInt()].keys.first);
                return SideTitleWidget(
                    meta: meta,
                    space: 8.0, // space between the chart and the title
                    child: getMonthlyLabel(date.month.toDouble()));
              }),
        ),
      )));
}

List<BarChartRodStackItem> getStackedData(Map<String, double> data) {
  List<BarChartRodStackItem> res = [];
  double current = 0;
  for (var item in data.entries) {
    res.add(BarChartRodStackItem(
        current, current + item.value, accountsColors[item.key]!));
    current += item.value;
  }
  return res;
}

List<BarChartGroupData> _buildAccountBarGroups(
    Map<String, Map<String, double>> trend) {
  List<BarChartGroupData> res = [];
  int index = 0;
  for (var item in trend.entries) {
    double total = item.value.values.reduce((v, e) => v + e);
    res.add(BarChartGroupData(x: index, barRods: [
      BarChartRodData(
          toY: total,
          color: Colors.black,
          rodStackItems: getStackedData(item.value),
          width: 8)
    ]));
    index++;
  }
  return res;
}

BarChart prepareAccountTrendBar(Map<String, Map<String, double>> trend) {
  return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceEvenly,
      barGroups: _buildAccountBarGroups(trend),
      minY: 0,
      maxY: 6000,
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(show: true)));
}

List<BarChartGroupData> _buildStructureBarGroups(
    Map<String, double> structure) {
  List<BarChartGroupData> res = [];
  for (var item in structure.entries) {
    res.add(BarChartGroupData(x: tagsBar[item.key]!, barRods: [
      BarChartRodData(toY: -item.value, color: tg[item.key], width: 10)
    ]));
  }
  return res;
}

BarChart prepareMonthlyStructureBar(Map<String, double> structure) {
  return BarChart(BarChartData(
    alignment: BarChartAlignment.spaceEvenly,
    barGroups: _buildStructureBarGroups(structure),
    minY: 0,
    maxY: 1200,
    gridData: const FlGridData(show: true),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      // leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final String cat = tagsBar.entries
                .firstWhere((e) => e.value == value.toInt(),
                    orElse: () => const MapEntry("Unknown", 0))
                .key;
            // final String category = structure.keys.elementAt(value.toInt());
            return SideTitleWidget(
              meta: meta,
              child: Text(cat, style: const TextStyle(fontSize: 5)),
            );
          },
        ),
      ),
    ),
  ));
}

DataTable getReoccuring(Map<String, double> structure) {
  List<DataColumn> cols = [
    const DataColumn(label: Expanded(child: Text("Name"))),
    const DataColumn(label: Expanded(child: Text("Amount")))
  ];
  List<DataRow> rows = [];
  double total = 0.0;
  for (var obj in structure.entries) {
    rows.add(DataRow(cells: [
      DataCell(Text(obj.key.toString())),
      DataCell(Text(obj.value.toString()))
    ]));
    total += obj.value;
  }
  rows.add(DataRow(cells: [
    const DataCell(Text('total')),
    DataCell(Text(total.toString()))
  ]));

  return DataTable(columns: cols, rows: rows);
}
