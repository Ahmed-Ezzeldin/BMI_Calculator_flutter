import 'dart:async';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../models/database_helper.dart';

class Point {
  int xPoint;
  double yPoint;
  Point(this.xPoint, this.yPoint);
}

class ChartTab extends StatefulWidget {
  @override
  _ChartTabState createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  DatabaseHelper helper = DatabaseHelper();
  List<double> bmiList;
  List<charts.Series<Point, int>> _seriesLineData;

  @override
  void initState() {
    super.initState();
    getBmiList();
    super.initState();
  }

  void getBmiList() async {
    List<double> bmi = await helper.getBmiList();
    bmiList = bmi;
  }

  generatePoins() async {
    List<Point> pointList = [];
    for (int i = 0; i < bmiList.length; i++) {
      pointList.add(Point(i, bmiList[i]));
    }
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        id: 'Bmi Points',
        data: pointList,
        domainFn: (Point point, _) => point.xPoint,
        measureFn: (Point point, _) => point.yPoint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (bmiList == null) {
      Timer(Duration(milliseconds: 500), () {
        _seriesLineData = List<charts.Series<Point, int>>();
        generatePoins();
        setState(() {
          bmiList = bmiList;
        });
      });
      return Center(child: CircularProgressIndicator());
    } else if (bmiList.length == 0) {
      return Center(child: Text('No Record Found!'));
    } else {
      return buildChart();
    }
  }

  Widget buildChart() {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10),
      child: charts.LineChart(
        _seriesLineData,
        defaultRenderer: new charts.LineRendererConfig(
          includeArea: true,
          includeLine: true,
          includePoints: true,
          areaOpacity: 0.3,
          strokeWidthPx: 2,
          radiusPx: 5,
        ),
        behaviors: [
          charts.ChartTitle(
            'BMi Records',
            behaviorPosition: charts.BehaviorPosition.top,
            titleStyleSpec: charts.TextStyleSpec(fontSize: 25),
            innerPadding:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? 70
                    : 20,
            outerPadding:
                (MediaQuery.of(context).orientation == Orientation.portrait)
                    ? 70
                    : 5,
          ),
        ],
      ),
    );
  }
}
