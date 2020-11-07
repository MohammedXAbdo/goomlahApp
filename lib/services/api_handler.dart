import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class ApiHandler {
  final host;

  ApiHandler({@required this.host})
      : assert(host != null, "host shouldnt equall null");

  Future<http.Response> postData({
    Map<String, String> headers,
    String path,
    Map<String, String> queryParameters,
    String endpoint,
    @required dynamic body,
  }) async {
    final uri = Uri.https(host, path, queryParameters);
    final response = await http.post(uri, body: body, headers: headers);
    return response;
  }

  Future<http.Response> getData({
    String path,
    Map<String, String> queryParameters,
    String endpoint,
    Map<String, String> headers,
  }) async {
    final uri = Uri.https(host, path, queryParameters);
    final response = await http.get(uri, headers: headers);

    return response;
  }

  Future<http.Response> putData({
    Map<String, String> headers,
    String path,
    Map<String, String> queryParameters,
    String endpoint,
    dynamic body,
  }) async {
    final uri = Uri.https(host, path, queryParameters);
    final response = await http.put(uri, body: body, headers: headers);
    return response;
  }

  bool successResponse(int statusCode) {
    int r = (statusCode ~/ 100);
    return r == 2;
  }
}
