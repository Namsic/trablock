import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'trablock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

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
        title: Text(widget.title),
      ),
      body: ListView(  //리스트타일을 고정해놓는것이 아니라 뭔가 새로 만든 객채의 배열을 통해 만들어야 할듯(뇌피셜)
        children: <Widget>[
          ListTile(
            title: Text('여행1'),
              //onTap: , 탭 되었을때 넘어가는 기능
          ),
          ListTile(
            title: Text('여행2'),
            //onTap: ,
          ),
          ListTile(
            title: Text('여행3'),
            //onTap: ,
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: , 팝업을 통해 새로운 여행 만들 수 있는 기능
        tooltip: '새 여행 시작',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
