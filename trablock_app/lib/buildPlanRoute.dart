import 'package:flutter/material.dart';

class BuildPlanRoute extends StatefulWidget {
  static final routeName = '/build';
  @override
  _BuildPlanRouteState createState() => _BuildPlanRouteState();
}

class _BuildPlanRouteState extends State<BuildPlanRoute> {
  @override
  Widget build(BuildContext context) {
    List<Days> myTravelDays = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('일정수정'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 30,
                width: 300,
                color: Colors.blue,
                child: Center(
                  child: Text('블럭'),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('새 블럭 추가'),
                //onPressed: , 새로운 Destination 객체 추가,
              ),
              RaisedButton(
                child: Text('새 태그 추가'),
                //onPressed: , 새로운 시간태그 추가
              ),
              Draggable(
                child: Text('블럭1'),
                feedback: Text('블럭1'),
                childWhenDragging: Text('블럭1'),

              )

            ],
          )
        ],
      ),
    );
  }
}

class Days {
  // 여행일정의 하루. 여행지의 배열을 갖고 있고, 사용자가 블럭을 추가하면 배열에 추가되는 기능 구현 필요
  List<Destination> todayDestinationList = [];
}

class Destination {
  // 각각의 여행지.
  // 여행지의 길이는 특정한 설정이 없으면 1로 고정
  String name;
  int length = 1;

  Destination(this.name);
}
