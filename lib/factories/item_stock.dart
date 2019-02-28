class ItemStock {
  final String color;
  final String size;
  final String local;
  final String others;
  final String itemId;

  ItemStock({this.color, this.size, this.local, this.others, this.itemId});

  factory ItemStock.fromJson(Map<String, dynamic> json) {
    return ItemStock(
      color: json['color'],
      size: json['size'],
      local: json['local'],
      others: json['others'],
      itemId: json['itemid']
    );
  }
}