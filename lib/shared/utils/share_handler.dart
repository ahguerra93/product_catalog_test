import 'package:product_catalog_test/common/app_strings.dart';
import 'package:share_plus/share_plus.dart';

class ShareHandler {
  static Future<void> shareProduct({required String name, required String price, required String sku}) async {
    final shareText = AppStrings.shareProductText(name: name, price: price, sku: sku);
    await SharePlus.instance.share(ShareParams(text: shareText));
  }
}
