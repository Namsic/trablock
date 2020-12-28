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

class Days {
  // 여행일정의 하루. 여행지의 배열을 갖고 있고, 사용자가 블럭을 추가하면 배열에 추가되는 기능 구현 필요
  List<Destination> todayDestinationList = [];
}
