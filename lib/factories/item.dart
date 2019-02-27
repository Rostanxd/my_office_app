class Item {
  final String itemId;
  final String styleId;
  final String styleName;
  final String lineName;
  final String productName;
  final String seasonName;
  final double priceIva;
  final double priceNoIva;
  final String imagePath;
  final double rank;

  Item({
      this.itemId,
      this.styleId,
      this.styleName,
      this.lineName,
      this.productName,
      this.seasonName,
      this.priceIva,
      this.priceNoIva,
      this.imagePath,
      this.rank});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'],
      styleId: json['styleId'],
      styleName: json['styleName'],
      lineName: json['lineName'],
      productName: json['seasonName'],
      seasonName: json['seasonName'],
      priceIva: json['priceIva'],
      priceNoIva: json['priceNoIva'],
      imagePath: json['imagePath'],
      rank: json['rank']
    );
  }
}
