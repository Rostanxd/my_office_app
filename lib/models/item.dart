class Item {
  String itemId;
  String styleId;
  String styleName;
  String lineName;
  String productName;
  String seasonName;
  double priceIva;
  double priceNoIva;
  String imagePath;
  List<String> listImagesPath;
  double rank;

  Item(
      this.itemId,
      this.styleId,
      this.styleName,
      this.lineName,
      this.productName,
      this.seasonName,
      this.priceIva,
      this.priceNoIva,
      this.imagePath,
      this.listImagesPath,
      this.rank);

  Item.fromJson(Map<String, dynamic> json){
    this.itemId = json['itemId'];
    this.styleId = json['styleId'];
    this.styleName = json['styleName'];
    this.lineName = json['lineName'];
    this.productName = json['productName'];
    this.seasonName = json['seasonName'];
    this.priceIva = json['priceIva'];
    this.priceNoIva = json['priceNoIva'];
    this.imagePath = json['imagePath'];
    this.listImagesPath = json['listImagesPath'].cast<String>();
    this.rank = json['rank'];
  }
}

