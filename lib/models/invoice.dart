class Invoice extends Object{
  int year;
  String localId;
  String sequence;
  String customerId;
  String sellerId;
  String quantity;
  String discount;
  String amount;
  List<InvoiceDetail> detail;

  Invoice(this.year, this.localId, this.sequence, this.customerId,
      this.sellerId, this.discount, this.quantity, this.amount, this.detail);

  Invoice.fromJson(Map<String, dynamic> json){
   this.year = json['year'];
   this.localId = json['localId'];
   this.sequence = json['sequence'];
   this.customerId = json['cusromerId'];
   this.sellerId = json['sellerId'];
   this.quantity = json['quantity'];
   this.discount = json['discount'];
   this.amount = json['amount'];
   this.detail = json['detail'].cast<InvoiceDetail>();
  }
}

class InvoiceDetail extends Object {
  int year;
  String localId;
  String sequence;
  String itemId;
  String quantity;
  String price;
  String discount;
  String amount;

  InvoiceDetail(this.year, this.localId, this.sequence, this.itemId,
      this.quantity, this.price, this.discount, this.amount);

  InvoiceDetail.fromJson(Map<String, dynamic> json){
    this.year = json['year'];
    this.localId = json['localId'];
    this.sequence = json['sequence'];
    this.itemId = json['itemId'];
    this.quantity = json['quantity'];
    this.price = json['price'];
    this.discount = json['discount'];
    this.amount = json['amount'];
  }

}