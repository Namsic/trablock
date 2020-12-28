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
            child: EditBlockTower(myDestinationList),
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
                child: Card(child: Text('timeaaaaaaaaaaaaaaaa'),),
                feedback: Card(child: Text('time'),),
              ),
            ],
          ),
        ],
      ),
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
      children: result,
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
