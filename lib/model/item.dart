import 'dart:collection';
import 'dart:core';

class Item {
  String productName;
  String description;
  String organization;
  String imgUrl;
  int price;
  int count;
  Map<String, dynamic> mainFeatures = LinkedHashMap();
  Map<String, dynamic> extraFeatures = LinkedHashMap();

  static const String NAME = 'productName';
  static const String DESCRIPTION = 'description';
  static const String ORG = 'organization';
  static const String IMAGE = 'imgUrl';
  static const String PRICE = 'price';
  static const String COUNT = 'count';
  static const String MAIN_FEATURES = 'mainFeatures';
  static const String EXTRA_FEATURES = 'extraFeatures';

  Item({this.productName, this.description, this.organization, this.imgUrl,
      this.price, this.count, this.mainFeatures, this.extraFeatures});

  Item.fromFirestore(Map<String, dynamic> map) {
    this.productName = map['productName'];
    this.description = map['description'];
    this.organization = map['organization'];
    this.imgUrl = map['imgUrl'];
    this.price = map['price'];
    this.count = map['count'];
    this.mainFeatures = map['mainFeatures'];
    this.extraFeatures = map['extraFeatures'];
  }

  String getPriceString() {
    String sPrice = price.toString();
    StringBuffer sb = new StringBuffer();
    while (sPrice.length > 3) {
      for(int i = 0; i < 3; i++) {
        sb.write(sPrice[sPrice.length - i-1]);
      }
      sb.write(" ");
      sPrice = sPrice.substring(0, sPrice.length-3);
    }
    for(int i = 0; i < sPrice.length; i++) {
      sb.write(sPrice[sPrice.length-i-1]);
    }
    sPrice = new String.fromCharCodes(sb.toString().runes.toList().reversed);
    return sPrice;
  }

  String getFullDescription() {
    String res = description.replaceAll('\n', '\n\t');
    return '\t' + res;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Item &&
              runtimeType == other.runtimeType &&
              productName == other.productName &&
              description == other.description &&
              organization == other.organization &&
              imgUrl == other.imgUrl &&
              price == other.price &&
              count == other.count;

  @override
  int get hashCode =>
      productName.hashCode ^
      description.hashCode ^
      organization.hashCode ^
      imgUrl.hashCode ^
      price.hashCode ^
      count.hashCode;

  @override
  String toString() {
    return 'Item{_productName: $productName'
        ', _description: $description'
        ', _organization: $organization'
        ', _imgUrl: $imgUrl'
        ', _price: $price'
        ', _count: $count'
        ', $getFeatureToString'
        '}';
  }

  String getFeatureToString() => 'Features: '
      + (hasMainFeatures() ? 'with mainFeatures(size = $getMainFeaturesSize)'
          : 'without mainFeatures and ')
      + (hasExtraFeatures() ? 'with extraFeatures(size = $getExtraFeaturesSize)'
          : 'without extraFeatures');

  int getMainFeaturesSize() => mainFeatures.length;
  int getExtraFeaturesSize() => extraFeatures.length;

  bool hasMainFeatures() {
    if(mainFeatures == null) return false;
    return mainFeatures.isNotEmpty;
  }

  bool hasExtraFeatures() {
    if(extraFeatures == null) return false;
    return extraFeatures.isNotEmpty;
  }
}