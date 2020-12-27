import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final double _blockWidth = 150;
final double _blockHeight = 75;
final double _intervalHeight = 30;

final List<Travel> myTravelList = []; // 로컬 데이타베이스에서 불러올 예정
final List<Destination> myDestinationList = [Destination('aaaa'), Destination('bbbb')];


class Travel {
  // 각각의 여행. 여러 개의 여행지로 구성되어 있(을 예정이)다.
  String title;
  List<Destination> _plan;

  Travel(this.title);
}

class Destination {
  // 각각의 여행지.
  // 여행지의 길이는 특정한 설정이 없으면 1로 고정
  String name;
  int length = 1;

  Destination(this.name);
}

class GetWidget{
  static Container blockColumn({@required final List<Destination> desList, bool interval = false}){
    List<Widget> result = [];

    for(int i=0; i<desList.length; i++){
      result.add(_makeBlock(des: desList[i]));
      if (interval)
        result.add(_makeBlock(des: null));
    }

    return Container(
      width: _blockWidth,
      height: (_blockHeight + _intervalHeight) * desList.length,
      child: Column(children: result,),
    );
  }

  static Widget _makeBlock({final Destination des}){
    if (des == null){
      return DragTarget(builder: (context, List candidateData, rejectData){
        return Container(
          width: _blockWidth,
          height: _intervalHeight,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.black,
          ),
        );
      },
      onWillAccept: (data){print('aa'); return true;},);
    }
    return Container(
      width: _blockWidth,
      height: _blockHeight,
      child: Card(
        margin: EdgeInsets.zero,
        child: Text(des.name),
      ),
    );
  }
}
