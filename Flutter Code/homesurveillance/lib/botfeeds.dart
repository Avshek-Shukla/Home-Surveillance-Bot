import 'package:http/http.dart' as http;

void sendFlashData(int value, String camID) async {
  try {
    var response =
        await http.get(Uri.parse('$camID/control?var=flash&val=$value'));
    if (response.statusCode == 200) {
      // Request successful
      print('Flash Status Changed');
    } else {
      // Request failed
      print('Failed to send request');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

void controllerFeed(int data, String camID) async {
  try {
    var response =
        await http.get(Uri.parse('$camID/control?var=car&val=$data'));
    if (response.statusCode == 200) {
      // Request successful
      print('Bot Movement Success');
    } else {
      // Request failed
      print('Failed to send request');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

void changeSpeed(int data, String camID) async {
  try {
    var response =
        await http.get(Uri.parse('$camID/control?var=speed&val==$data'));
    if (response.statusCode == 200) {
      // Request successful
      print('Speed Changed Success');
    } else {
      // Request failed
      print('Failed to send request');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}
