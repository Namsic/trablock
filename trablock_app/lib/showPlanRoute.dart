import 'package:flutter/material.dart';
// 메인화면에서 각 계획 클릭시 나타날 화면. 작성된 계획을 보기 편하게 보여줘야 할듯

List<Destination> myDestinationList = [];

class ShowPlanRoute extends StatefulWidget {
  static final routeName = '/show';
  @override
  _ShowPlanRouteState createState() => _ShowPlanRouteState();
}

class _ShowPlanRouteState extends State<ShowPlanRoute> {
  @override
  Widget build(BuildContext context) {
    final Travel _travel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(  // 계획 수정버튼 등 필요
        title: Text(_travel.title),
      ),
      body: Text('hi'),
    );
  }
}

class Travel {
  // 각각의 여행. 여러 개의 계획으로 구성되어 있(을 예정이)다.
  String title;

  Travel(this.title);
}

class Destination {
  // 각각의 여행지.
  // 여행지의 길이는 특정한 설정이 없으면 1로 고정
  String name;
  int length = 1;

  Destination(this.name);
}