import 'package:flutter/material.dart';
import 'package:trablock_app/showPlanRoute.dart';

class BuildPlanRoute extends StatefulWidget {
  static final routeName = ShowPlanRoute.routeName + '/build';
  @override
  _BuildPlanRouteState createState() => _BuildPlanRouteState();
}

class _BuildPlanRouteState extends State<BuildPlanRoute> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Draggable(
          child: PlaceBlock(0),
          feedback: PlaceBlock(1),
        ),
      ],
    );
  }
}

class PlaceBlock extends StatelessWidget {
  final imageIndex;

  PlaceBlock(this.imageIndex);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('images/block' + imageIndex + '.png'),
          Text('a'),
        ],
    );
  }
}

