import 'dart:convert';
import 'dart:io';

class HttpHelper extends HttpOverrides {
  // static String apiUrl = "http://65.0.41.80/v2";
  static String apiUrl = "http://65.0.41.80/v2";
  static String nftEndPoint = "api/v1/claimNft";

  static Future<dynamic> performPostRequest(server, command, payload,
      {Map<String, String> headers}) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        command.isEmpty ? Uri.parse(server) : Uri.parse('$server/$command'));
    request.headers.set('content-type', 'application/json');
    if (headers == null) {
      request.add(utf8.encode(json.encode(payload)));
    } else {
      headers.entries.forEach(
        (header) => request.headers.add(header.key, header.value),
      );
      request.headers.add('body', json.encode(payload));
      request.add(utf8.encode(json.encode(payload)));
    }
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  static Future<dynamic> performGetRequest(server, command) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse('$server/$command'));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    if (reply.length > 0) return jsonDecode(reply);
    return null;
  }
}
