import 'package:intl/intl.dart';

String formatDurationInMmSs(Duration duration){

  final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return '$mm:$ss';

}

String formatThousands(int value){

  var formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(value);
}

String stripUrl(String text){
  return text.replaceAll(RegExp(r"(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?"), "");
}

String stripHTML(text){
  return Bidi.stripHtmlIfNeeded(text);
}