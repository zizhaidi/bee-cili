import 'package:url_launcher/url_launcher.dart';

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false);
  } else {
    throw '不能加载这个链接';
  }
}
