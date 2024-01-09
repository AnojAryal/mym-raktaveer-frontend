import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/models/graph_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminGraph extends StatefulWidget {
  @override
  _AdminGraphState createState() => _AdminGraphState();
}

class _AdminGraphState extends State<AdminGraph> {
  List<GraphModel> _graphData = [];

  @override
  void initState() {
    super.initState();
    _retrieveDataFromFirestore();
  }

  void _retrieveDataFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final graphData = await firestore.collection('your_collection').get();

    setState(() {
      _graphData = graphData.docs
          .map((doc) => GraphModel(
                users: doc.data()['product_name'],
                count: doc.data()['count'],
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCartesianChart(
            legend: Legend(isVisible: true),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<GraphModel, String>(
                dataSource: _graphData,
                xValueMapper: (GraphModel data, _) => data.users,
                yValueMapper: (GraphModel data, _) => data.count,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
