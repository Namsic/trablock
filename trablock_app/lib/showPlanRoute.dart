import 'package:flutter/material.dart';
import './buildPlanRoute.dart';

List<Days> myTravelDays = [];

class ShowPlanRoute extends StatefulWidget {
  static final routeName = '/show';
  @override
  _ShowPlanRouteState createState() => _ShowPlanRouteState();
}

class _ShowPlanRouteState extends State<ShowPlanRoute> {
  // 메인화면에서 각 계획 클릭시 나타날 화면. 작성된 계획을 보기 편하게 보여줘야 할듯
  @override
  Widget build(BuildContext context) {
    final Travel _travel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(  // 계획 수정버튼 등 필요
        title: Text(_travel.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.edit),
            tooltip : '여행 일정을 수정하기',
            onPressed: (){
              Navigator.pushNamed(
                  context,
                  BuildPlanRoute.routeName,
                  arguments: myTravelDays
              );
            },
          )
        ],
      ),

    );
  }
}

class Travel {
  // 각각의 여행. 여러 개의 계획으로 구성되어 있(을 예정이)다.
  String title;

  Travel(this.title);
}
