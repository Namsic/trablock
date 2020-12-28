import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

class EditPlanRoute extends StatefulWidget {
  static final routeName = '/edit';
  @override
  _EditPlanRouteState createState() => _EditPlanRouteState();
}

class _EditPlanRouteState extends State<EditPlanRoute> {
  @override
  Widget build(BuildContext context) {
    Travel _travel = ModalRoute.of(context).settings.arguments;
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
            child: BuildDayPage(_travel.days),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Draggable(
                child: Card(child: Text('block'),),
                feedback: Card(child: Text('block'),),
                childWhenDragging: Container(),
                data: Destination('name'),
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
  //input : List<List<Destination>> 날짜별 여행지 목록
  //output : 좌우로 넘길 수 있는 ViewPage 위젯
  final List<List<Destination>> dayList;
  BuildDayPage(this.dayList);


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
          itemCount: widget.dayList.length,
          physics: PageScrollPhysics(),
          itemBuilder: (context, page) {
            return Stack(
              children: <Widget>[
                Center(child:_EditBlockTower(widget.dayList[page])),
                Positioned(
                  child: DragTarget(
                    builder: (context, List<Destination>candidateData, rejectedData){
                      return Container(width: 70, height: 70, color: Colors.red,);
                    },
                    onAccept: (data){
                      setState(() {
                        if (widget.dayList[pageIndex].contains(data))
                          widget.dayList[pageIndex].remove(data);
                      });
                    },
                  ),
                  left: 70,
                  bottom: 30,
                )
              ],
            );
          },
        ),
      ],
    );
  }
}


class _EditBlockTower extends StatefulWidget {
  final List<Destination> _destinationList;

  _EditBlockTower(this._destinationList);

  @override
  _EditBlockTowerState createState() => _EditBlockTowerState();
}

class _EditBlockTowerState extends State<_EditBlockTower> {
  static final double _blockWidth = 200;
  static final double _blockHeight = 60;
  static final double _intervalHeight = 20;
  static final double _intervalHeightWide = 40;

  final List<Widget> _intervalList = [];

  int _onWillAcceptIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];
    _intervalList.clear();

   for(int i=0; i<widget._destinationList.length; i++){
      result.add(_makeInterval(index: i));
      result.add(_makeBlock(index: i));
    }
   result.add(_makeInterval(index: widget._destinationList.length));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: result
    );
  }

  // 블럭 Draggable return
  Widget _makeBlock({@required final int index}){
    return Draggable(
      child: Container(
        width: _blockWidth,
        height: _blockHeight,
        color: Colors.orange,
        child: Text(widget._destinationList[index].name),
      ),
      feedback: Container(
        width: _blockWidth,
        height: _blockHeight,
        color: Colors.orange,
        child: Text(widget._destinationList[index].name),
      ),
      childWhenDragging: Container(),
      data: widget._destinationList[index],
    );
  }
  // 틈 DragTarget return
  Widget _makeInterval({@required final int index}){
    return DragTarget(
      builder: (context, List<Destination> candidateData, rejectData){
        return Container(
          width: _blockWidth,
          height: _onWillAcceptIndex == index
              ? _intervalHeightWide
              : _intervalHeight,
          color: Colors.black,
        );
      },
      onWillAccept: (data){
        _onWillAcceptIndex = index;
        return true;
      },
      onLeave: (data){
        _onWillAcceptIndex = -1;
      },
      onAccept: (data){
        setState(() {
          if (widget._destinationList.contains(data)){
            int position = widget._destinationList.indexOf(data);
            widget._destinationList.removeAt(position);
            index > position
                ? widget._destinationList.insert(index - 1, data)
                : widget._destinationList.insert(index, data);
          }
          else {
            widget._destinationList.insert(index, data);
          }
          _onWillAcceptIndex = -1;
        });
      },
    );
  }
}
