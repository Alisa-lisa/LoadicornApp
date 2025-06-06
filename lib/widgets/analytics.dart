import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:loadiapp/models/tag.dart';
import 'package:loadiapp/widgets/misc.dart';

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
Color noCustomTagColor = Colors.indigo[300]!;

Map<Tag, int> getTagsBarsIndexes(List<Tag> tags) {
  Map<Tag, int> res = {};
  int t = 0;
  for (Tag item in tags) {
    res[item] = t;
    t++;
  }
  return res;
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
    );
  });
}

BarChart prepareTotalTrendBar(List<Map<String, List<String>>> trend) {
  /// Total incoming and outgoing per each month
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
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

Color reconstructColor(String channels) {
  List<String> ch = channels.split("-");
  return Color.from(
      alpha: double.parse(ch[0]),
      red: double.parse(ch[1]),
      green: double.parse(ch[2]),
      blue: double.parse(ch[3]));
}

List<BarChartGroupData> _buildStructureBarGroups(
    Map<String, double> structure, List<Tag> tags) {
  List<BarChartGroupData> res = [];
  Map<Tag, int> tagsMapping = getTagsBarsIndexes(tags);
  for (var item in structure.entries) {
    Tag t = tags.firstWhere((tag) => tag.name == item.key);
    Color c = t.color != null ? reconstructColor(t.color!) : Colors.red;
    res.add(BarChartGroupData(
        x: tagsMapping[t]!,
        barRods: [BarChartRodData(toY: -item.value, color: c, width: 10)]));
  }
  return res;
}

BarChart prepareMonthlyStructureBar(
    Map<String, double> structure, List<Tag> tags) {
  Map<Tag, int> tagsMapping = getTagsBarsIndexes(tags);
  return BarChart(BarChartData(
    alignment: BarChartAlignment.spaceEvenly,
    barGroups: _buildStructureBarGroups(structure, tags),
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
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final String cat = tagsMapping.entries
                .firstWhere((e) => e.value == value.toInt(),
                    orElse: () => const MapEntry(
                        Tag(
                            id: 0,
                            description: "Unknown",
                            name: "Unknown",
                            color: "1.0-0.0-0.0-0.0"),
                        0))
                .key
                .name;
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
    DataCell(Text(
      total.toString(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    ))
  ]));

  return DataTable(columns: cols, rows: rows);
}
