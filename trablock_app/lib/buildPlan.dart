import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:trablock_app/showPlanRoute.dart';

class BuildPlanRoute extends StatefulWidget {
  static final routeName = ShowPlanRoute.routeName + '/build';
  @override
  _BuildPlanRouteState createState() => _BuildPlanRouteState();
}

class _BuildPlanRouteState extends State<BuildPlanRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: Center(child:GetWidget.blockColumn(desList: myDestinationList, interval: true)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Draggable(
                child: Card(child: Text('block'),),
                feedback: Card(child: Text('block'),),
                childWhenDragging: Container(),
              ),
              Draggable(
                child: Card(child: Text('time'),),
                feedback: Card(child: Text('time'),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



