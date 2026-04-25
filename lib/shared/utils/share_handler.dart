import 'package:share_plus/share_plus.dart';

class ShareHandler {
  static Future<void> shareProduct({required String name, required String price, required String sku}) async {
    final shareText = 'Name: $name\nPrice: $price\nSKU: $sku';
    await SharePlus.instance.share(ShareParams(text: shareText));
  }
}
