class CardInfo extends Object {
  String image;
  String title1;
  String title2;
  String subtitle1;
  String subtitle2;

  CardInfo(
      this.image, this.title1, this.title2, this.subtitle1, this.subtitle2);

  CardInfo.fromJson(Map<String, dynamic> json){
    this.image = json['iamge'];
    this.title1 = json['title1'];
    this.title2 = json['title2'];
    this.subtitle1 = json['subtitle1'];
    this.subtitle2 = json['subtitle2'];
  }
}
