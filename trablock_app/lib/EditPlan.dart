import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

class EditPlanRoute extends StatelessWidget {
  static final String routeName = '/edit';

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
                data: Destination('name') as Insertable,
              ),
              Draggable(
                child: Card(child: Text('time'),),
                feedback: Card(child: Text('time'),),
                data: TimeTag(time: '11:00') as Insertable,
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
  int pageStartIndex = 0;
  
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
      index: pageStartIndex,
      children: <Widget>[
        PageView.builder(
          itemCount: widget.dayList.length+1,
          physics: PageScrollPhysics(),
          itemBuilder: (context, page) {
            if (page < widget.dayList.length)
              return BlockTower(destinationList: widget.dayList[page], onEditMode: true,);
            else
              return Center(child: _newPage());
          },
        ),
      ],
    );
  }
  Widget _newPage() {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Icon(Icons.add) ,//Text('', style: TextStyle(fontSize: 24))
          onPressed: (){
            setState(() {
              widget.dayList.add([]);
            });
          },
        ),
      ),
    );
  }
}


class BlockTower extends StatefulWidget {
  // Destination, TimeTag 정보를 위젯으로 변환
  /* input:
   * List<Destination> _destinationList
     - required
     - 현재 계획중인 목적지 및 그 순서 정보 포함
   * bool onEditMode
     - optional(default: false)
     - 드래그 등을 통한 수정 가능 여부
   */
  final List<Destination> _destinationList;
  final bool _onEditMode;

  BlockTower({@required List<Destination> destinationList, onEditMode: false})
      : _destinationList = destinationList, _onEditMode = onEditMode;

  @override
  _BlockTowerState createState() => _BlockTowerState();
}

class _BlockTowerState extends State<BlockTower> {
  static final double _blockWidth = 200;
  static final double _blockHeight = 60;
  static final double _intervalHeight = 20;
  static final double _intervalHeightWide = 40;

  static BlockTower _onDragWidget = null;

  int _onWillAcceptIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget._onEditMode)
      return _buildEditBlockTower();
    return _buildBlockTower();
  }

  Widget _buildBlockTower() {
    // 상호작용 불가능한 BlockTower
    List<Widget> result = [];

    for(int i=0; i<widget._destinationList.length; i++) {
      result.add(_makeBlock(index: i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: result,
    );
  }
  Widget _buildEditBlockTower(){
    // 드래그 및 수정 가능한 BlockTower
    List<Widget> result = [];

    for(int i=0; i<widget._destinationList.length; i++){
      result.add(_makeInterval(index: i));
      result.add(Draggable(
        child: _makeBlock(index: i),
        feedback: _makeBlock(index: i),
        childWhenDragging: Container(),
        data: widget._destinationList[i] as Insertable,
        onDragStarted: () {
          setState(() {
            _onDragWidget = widget;
          });
        },
        onDragEnd: (details) {
          setState(() {
            _onDragWidget= null;
          });
        },
      ));
    }
    result.add(_makeInterval(index: widget._destinationList.length));

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: result
        ),
        _makeRemoveBar(),
      ],
    );
  }

  Widget _makeBlock({@required final int index}){
    // 블럭 Widget
    Destination des = widget._destinationList[index];
    return Container(
        width: _blockWidth,
        height: _blockHeight,
        color: Colors.orange,
        child: Text(des.name),
      );
  }
  Widget _makeTimeTag(){
    return Container();
  }
  Widget _makeInterval({@required final int index}){
    // 블럭 사이 공간에 넣을 DragTarget
    return DragTarget(
      builder: (context, List<Insertable> candidateData, rejectData){
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
        switch (data.runtimeType) {
          case Destination:
            setState(() {
              if (_onDragWidget == null){
                // 새 블럭을 추가하는 경우
                widget._destinationList.insert(index, data);
              } else if (_onDragWidget == widget) {
                // 도달한 부분 일자와 출발한 부분 일자가 동일한 경우
                int position = _onDragWidget._destinationList.indexOf(data);
                _onDragWidget._destinationList.removeAt(position);
                index > position
                  ? widget._destinationList.insert(index - 1, data)
                  : widget._destinationList.insert(index, data);
              } else {
                _onDragWidget._destinationList.remove(data);
                widget._destinationList.insert(index, data);
              }
              _onWillAcceptIndex = -1;
            });
            break;

          case TimeTag:
            break;
        }
      },
    );
  }
  Widget _makeRemoveBar(){
    return DragTarget(
      builder: (context, List<Insertable> candidateData, rejectedData){
        return Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    height: _onDragWidget != null ? 50 : 0,
                    color: Colors.red,
                  )
              )
            ]
        );
      },
      onAccept: (data) {
        switch (data.runtimeType) {
          case Destination:
            _onDragWidget._destinationList.remove(data);
            break;

          case TimeTag:
            break;
        }
      },
    );
  }
}
