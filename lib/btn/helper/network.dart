import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkConnectNetwork() async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.none)) {
    print("Không có kết nối Internet");
    return false;
  }
  else{
    print("Đang tải truyện ...");
    return true;
  }
}