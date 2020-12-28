import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trablock_app/buildPlanRoute.dart';
import './showPlanRoute.dart';

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
        BuildPlanRoute.routeName: (context) => BuildPlanRoute(),
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
  String _travelname = '';

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
                title: Text('여행이름입력'),
                content: TextField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: '입력해 주세요'),
                    onChanged: (String str) {
                      setState(() => _travelname = str);
                    },
                ),//입력칸 추가완료
                actions: <Widget>[
                  FlatButton(
                    child: Text("확인"),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        myTravelList.add(Travel(_travelname));
                      });
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


