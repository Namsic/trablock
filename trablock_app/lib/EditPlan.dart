import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class EditPlanRoute extends StatelessWidget {
  static final routeName = '/edit';

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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: BuildDayPage(_travel),
                ),
              ]
            ),
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
      ),

    );
  }
}


class BuildDayPage extends StatefulWidget {
  //여행날짜와 여행지 리스트를 입력받으면 그에 해당하는 viewpage를 생성하는 클래스
  //input : List<List<Destination>> 날짜별 여행지 목록
  //output : 좌우로 넘길 수 있는 ViewPage 위젯
  final Travel travel;
  BuildDayPage(this.travel);


  @override
  _BuildDayPageState createState() => _BuildDayPageState();
}

class _BuildDayPageState extends State<BuildDayPage> {
  PageController controller;
  int pageStartIndex = 0;
  final _currentPageNotifier = ValueNotifier<int>(0);
  final double _dotSize = 12;
  final double _selectedDotSize = 15;
  
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
          itemCount: widget.travel.days.length+1,
          physics: PageScrollPhysics(),
          onPageChanged: (int index){
            _currentPageNotifier.value = index;
          },
          itemBuilder: (context, page) {
            if (page < widget.travel.days.length) {
              return Stack(
                children: <Widget>[
                  BlockTower(
                  destinationList: widget.travel.days[page], onEditMode: true,),
                  _buildCircleIndicator()
                ]
              );
            }
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
              widget.travel.days.add([]);
            });
          },
        ),
      ),
    );
  }
  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          size: _dotSize,
          selectedSize: _selectedDotSize,
          itemCount: widget.travel.days.length,
          currentPageNotifier: _currentPageNotifier,
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

  final List<Widget> _intervalList = [];

  int _onWillAcceptIndex = -1;
  bool _onDrag = false;

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
    _intervalList.clear();

    for(int i=0; i<widget._destinationList.length; i++){
      result.add(_makeInterval(index: i));
      result.add(Draggable(
        child: _makeBlock(index: i),
        feedback: _makeBlock(index: i),
        childWhenDragging: Container(),
        data: widget._destinationList[i] as Insertable,
        onDragStarted: () {
          setState(() {
            _onDrag = true;
          });
        },
        onDragEnd: (details) {
          setState(() {
            _onDrag = false;
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
        // Remove_bar
        DragTarget(
          builder: (context, List<Insertable> candidateData, rejectedData){
            return Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: _onDrag ? 50 : 0,
                    color: Colors.red,
                  )
                )
              ]
            );
          },
          onAccept: (data){
            if (widget._destinationList.contains(data))
              widget._destinationList.remove(data);
          },
        )
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
        if (data.runtimeType == Destination) {
          setState(() {
            if (widget._destinationList.contains(data)) {
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
        }
        else if(data.runtimeType == TimeTag){
          print('TT');
        }
      },
    );
  }
}
