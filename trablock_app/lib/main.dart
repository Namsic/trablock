import 'package:flutter/material.dart';

final List<Travel> myTravelList = []; // 로컬 데이타베이스에서 불러올 예정

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName: (context) => MyHomePage(),
        ShowPlanRoute.routeName: (context) => ShowPlanRoute(),
      },
    );
  }
}

// MyHomePage 대신 다른 이름 필요성 느낌
class MyHomePage extends StatefulWidget {
  static final routeName = '/';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('관리메뉴'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('일정 제거'),
              onTap : () {
                // Upadte the state of the app
                // 제거할 일정 선택하는 기능
                Navigator.pop(context);

              },
            ),
            ListTile(
              title: Text('설정'),
              onTap: () {
                // Upadte the state of the app
                // 기타 설정창으로 넘어가는 기능
                Navigator.pop(context);

              },
            ),

          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('widget.title'),
      ),
      body: TravelListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('새 여행 만들기'),
                content: Text('입력칸 추가예정'),
                actions: <Widget>[
                  FlatButton(
                    child: Text("확인"),
                    onPressed: (){
                      setState(() {
                        myTravelList.add(Travel("my_trablock"));
                      });
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
          );
        },
        tooltip: '새 여행 시작',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


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
      ),
    );
  }
}


class TravelTile extends StatelessWidget{
  // 리스트뷰에 보여질 각각의 타일들
  TravelTile(this._travel);

  final Travel _travel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_travel.title),
      onTap: (){  // 클릭 시 해당하는 여행계획 화면으로 이동
        Navigator.pushNamed(
            context,
            ShowPlanRoute.routeName,
            arguments: _travel
        );
      },
    );
  }
}

class TravelListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myTravelList.length,
      itemBuilder: (BuildContext context, int index){
        return TravelTile(myTravelList[index]);
      },
    );
  }
}


class Travel {
  // 각각의 여행. 여러 개의 계획으로 구성되어 있(을 예정이)다.
  String title;

  Travel(this.title);
}