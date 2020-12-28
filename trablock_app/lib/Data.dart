final List<Travel> myTravelList = []; // 로컬 데이타베이스에서 불러올 예정

class Travel {
  // 각각의 여행. 여러 개의 여행지로 구성되어 있(을 예정이)다.
  String title;
  List<List<Destination>> days = [[Destination('aaaa'), Destination('bbbb')],[Destination('Seoul'),Destination('Busan')]];

  Travel(this.title);
}

class Destination {
  // 각각의 여행지.
  // 여행지의 길이는 특정한 설정이 없으면 1로 고정
  String name;
  int length = 1;

  Destination(this.name);
}
