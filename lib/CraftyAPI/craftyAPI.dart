import 'dart:io';

import 'package:craftycontroller/CraftyAPI/static/models/server.dart';
import 'package:craftycontroller/CraftyAPI/static/routes.dart' as routes;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CraftyClient {
  final String API_TOKEN;
  final String URL;
  final HttpClient httpClient = new HttpClient();

  CraftyClient(this.API_TOKEN, this.URL) {
    // anwser to certificate: https://stackoverflow.com/questions/49839729/how-to-post-data-to-https-server-in-dart
    bool trustSelfSigned = true;
    httpClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  }


  Future<String> _makeGetRequest(
      String apiRoute, Map<String, String> params) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response= await ioClient.get(uri);
    //log(response.body);
    return response.body;
  }

  Future<String> _makePostRequest(
      String apiRoute, Map<String, String> params, String body) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response= await ioClient.post(uri,body: body);
    // todo Close the connection idk when 
    return response.body;
  }

  Future<ServerStat> getServerStats() async {
    String response =
    await _makeGetRequest(routes.CraftyAPIRoutes.SERVER_STATS, null);
    return serverStatFromJson(response);
  }

}
