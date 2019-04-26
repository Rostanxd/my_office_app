class ItemStock {
  String color;
  String size;
  int local;
  int others;
  String itemId;

  ItemStock(this.color, this.size, this.local, this.others, this.itemId);

  ItemStock.fromJson(Map<String, dynamic> json){
    this.color = json['color'];
    this.size = json['size'];
    this.local = json['local'];
    this.others = json['others'];
    this.itemId = json['itemId'];
  }
}