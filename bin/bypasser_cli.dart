import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:colorize/colorize.dart' as colors;

// Function to validate urls
validateUrl(String url) async {
  return Uri.parse(url).host == "" ? false : true;
}

// Raise errors
raiseErr({String emsg = ""}) async {
  colors.color(emsg == "" ? "\nOops, Something went wrong!" : "\n$emsg",
      front: colors.Styles.RED);
  exit(1);
}

// Function to check internet connection
checkConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    await raiseErr(emsg: "No internet connection!");
  }
}

// Sends post request to bypass.vip api
bypass(String url) async {
  var resp = (await http
          .post(Uri.parse("https://api.bypass.vip/"), body: {"url": url}))
      .body;
  Map<String, dynamic> jResp = json.decode(resp) as Map<String, dynamic>;
  if (jResp['success']) {
    var bypU = jResp['destination'];
    if (bypU == null) {
      await raiseErr();
    }
    colors.color("\nBypass Successfull ✅,", isBold: true, isItalic: true);
    print("Url: $bypU");
  } else {
    await raiseErr();
  }
}

void main(List<String> args) async {
  // Checks if the device is connected to internet
  await checkConnection();
  // Checks if an url is passed as an argument
  if (args.isNotEmpty && await validateUrl(args[0])) {
    await bypass(args[0]);
    return;
  }
  // Start messages
  colors.color("\n BYPASSER.VIP - CLI \n",
      front: colors.Styles.CYAN, isBold: true);
  colors.color(" An Unofficial cli for bypasser.vip API \n", isItalic: true);

  stdout.write("\n> Enter the url you need to bypass: ");
  var url = stdin.readLineSync();

  // Checks if the url is valid
  if (await validateUrl(url!)) {
    await bypass(url);
  } else {
    return colors.color("\nWtf, is this an url?", front: colors.Styles.RED);
  }
}
