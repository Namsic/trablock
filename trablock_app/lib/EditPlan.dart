import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

class EditPlanRoute extends StatefulWidget {
  static final routeName = '/build';
  @override
  _EditPlanRouteState createState() => _EditPlanRouteState();
}

class _EditPlanRouteState extends State<EditPlanRoute> {
  @override
  Widget build(BuildContext context) {
    Travel _travel = ModalRoute.of(context).settings.arguments;
    List<List<Destination>> myDayList = _travel.days;
    int _travelterm = _travel.daysCount;
    //List<Destination> myDestinationList = _travel.plan;// 각 여행마다 destinationList를 갖기 위해 변경
    //여행 기간을 추가시키는 기능을 구현하기 위해서 travel.days와 travel.daysCount를 모두 변경시켜줘야 함.
    return Scaffold(
      appBar: AppBar(
        title: Text('일정수정'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
           //IndexedStack(
           //  index: dayIndex,
           //  children: <Widget>[
           //    PageView.builder(
           //      itemBuilder: (context, page) {
           //        return Expanded(
           //          child: EditBlockTower(myDestinationList),
           //        );
           //      },
           //    )
           //  ],
          // ),
          Expanded(
            child: BuildDayPage(myDayList, _travelterm),
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
      )
    );
  }
}

class BuildDayPage extends StatefulWidget {
  //여행날짜와 여행지 리스트를 입력받으면 그에 해당하는 viewpage를 생성하는 클래스
  //input : List<List<Destination>> 날짜별 여행지 목록, int 여행기간
  //output : 좌우로 넘길 수 있는 ViewPage 위젯
  final List<List<Destination>> dayList;
  final int term;
  BuildDayPage(this.dayList, this.term);

  @override
  _BuildDayPageState createState() => _BuildDayPageState();
}

class _BuildDayPageState extends State<BuildDayPage> {
  PageController controller;
  int pageIndex = 0;
  @override
  void initState() {
    controller = PageController();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: pageIndex,
      children: <Widget>[
        PageView.builder(
          itemCount: widget.term,
          physics: PageScrollPhysics(),
          itemBuilder: (context, page) {
            return Center(
              child: EditBlockTower(widget.dayList[page])
            );
          },
        )
      ],
    );
  }
}


class EditBlockTower extends StatefulWidget {
  final List<Destination> desList;

  EditBlockTower(this.desList);

  @override
  _EditBlockTowerState createState() => _EditBlockTowerState();
}

class _EditBlockTowerState extends State<EditBlockTower> {
  // 각종 상수
  static final double _blockWidth = 200;
  static final double _blockHeight = 60;
  static final double _intervalHeight = 20;
  static final double _intervalHeightWide = 40;

  // 블럭 사이 틈을 의미하는 위젯들
  final List<Widget> _intervalList = [];

  // AnimationController _controller;
  // Animation<Size> _heightAnimation;
  int onWillAcceptIndex = -1;
  // @override
  // void initState(){
  //   super.initState();
  //   _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  //   _heightAnimation = Tween<Size>(
  //     begin: Size(double.infinity, 260),
  //     end: Size(double.infinity, 320)
  //   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCirc));
  //   _heightAnimation.addListener(() {setState((){});});
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    _intervalList.clear();


    // 틈 위젯과 블럭 위젯 번갈아 입력력
   for(int i=0; i<widget.desList.length; i++){
      result.add(_makeInterval(index: i));
      result.add(_makeBlock(des: widget.desList[i]));
    }
   result.add(_makeInterval(index: widget.desList.length));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: result
    );
  }

  // 블럭 Draggable return
  Widget _makeBlock({@required final Destination des}){
    return Container(
      width: _blockWidth,
      height: _blockHeight,
      color: Colors.orange,
      child: Text(des.name),
    );
  }
  // 틈 DragTarget return
  Widget _makeInterval({@required int index}){
    return DragTarget(
      builder: (context, candidateData, rejectData){
        return Container(
          width: _blockWidth,
          height: onWillAcceptIndex == index ? _intervalHeightWide : _intervalHeight,
          //color: Colors.black,
        );
      },
      onWillAccept: (data){
        onWillAcceptIndex = index;
        return true;
      },
      onLeave: (data){
        onWillAcceptIndex = -1;
      },
      onAccept: (data){
        setState(() {
          widget.desList.insert(index, Destination('name'));
          onWillAcceptIndex = -1;
        });
      },
    );
  }
}
