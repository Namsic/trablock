// 테스트용
import 'package:flutter/cupertino.dart';

Travel _testTravel(){
  Travel res = Travel('test');
  res.days = [[Destination('aaaa'), Destination('bbbb')],[Destination('Seoul'),Destination('Busan')]];
  return res;
}

final List<Travel> myTravelList = [_testTravel()]; // 로컬 데이타베이스에서 불러올 예정

class Travel {
  // 각각의 여행. Destination, TimeTag 정보를 포함한다.
  String title;
  List<List<Destination>> days = [];

  Travel(this.title);
}

class Destination {
  // 각각의 여행지.
  String name;
  String address;

  Destination(this.name);
}

class TimeTag{
  // Destination 시작과 끝의 시간 정보(Optional)
  String time0;
  String time1;

  TimeTag({@required String time, String timeExtra = ''})
      : time0 = time,
        time1=timeExtra;
}