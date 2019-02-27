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
  final List<String> listImagesPath;
  final double rank;

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
}

