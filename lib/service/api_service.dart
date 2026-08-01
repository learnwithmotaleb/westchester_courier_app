import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:logger/logger.dart';
import '../helper/local_db/local_db.dart';
import '../helper/no_internet/controller/no_internet_controller.dart';

final log = Logger();

typedef ApiResult = Response;

class ApiClient {
  static const defaultTimeout = Duration(seconds: 30);

  Future<Map<String, String>> _headers({
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = <String, String>{"Content-Type": "application/json"};

    // Basic Auth
    if (isBasic) {
      const basicAuth = "Basic your_basic_key";
      headers["Authorization"] = basicAuth;
    }

    // Bearer Token
    if (isToken) {
      String? token = await SharePrefsHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      } else {
        print("Token is missing!");
      }
    }

    // Custom Headers
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// ---------------- Master Request Handler ---------------------
  /// ---------------- Master Request Handler ---------------------
  Future<ApiResult> safeRequest(
    Future<http.Response> Function() requestFn, {
    required String url,
    String method = "GET",
    bool checkInternet = true,
    dynamic requestBody,
  }) async {
    try {
      _logRequest(url, method, requestBody);

      // Optional: check internet before request
      if (checkInternet && Get.isRegistered<InternetController>()) {
        final controller = Get.find<InternetController>();
        if (!controller.isConnected.value) {
          return _handleException("No internet connection!");
        }
      }

      final response = await requestFn().timeout(defaultTimeout);

      // Update internet status on success
      if (Get.isRegistered<InternetController>()) {
        Get.find<InternetController>().setConnected();
      }

      return _handleResponse(response);
    }
    // No internet
    on SocketException {
      if (Get.isRegistered<InternetController>()) {
        Get.find<InternetController>().setDisconnected();
      }
      return _handleException("No internet connection!");
    }
    // Timeout
    on TimeoutException {
      return _handleException("Request timeout. Please try again.");
    }
    // Client error
    on http.ClientException catch (e) {
      return _handleException("Client error: ${e.message}");
    }
    // Unknown error
    catch (e) {
      return _handleException("Unexpected error: $e");
    }
  }

  /// ---------------- Response Handler ---------------------------
  ApiResult _handleResponse(http.Response response) {
    final String requestUrl = response.request?.url.toString() ?? 'Unknown URL';
    final String requestMethod = response.request?.method ?? 'Unknown Method';

    log.i(
      "====== API [$requestMethod] Response ======\n"
      "URL: $requestUrl\n"
      "Status Code: ${response.statusCode}",
    );

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
      // Pretty print JSON in console
      const encoder = JsonEncoder.withIndent('  ');
      log.d("Response Body:\n${encoder.convert(decoded)}");
    } catch (_) {
      decoded = response.body;
      log.d("Response Body (Raw):\n$decoded");
    }

    return Response(
      statusCode: response.statusCode,
      body: decoded,
      bodyString: response.body,
      statusText: response.reasonPhrase,
    );
  }

  /// ---------------- Error Handler -------------------------------
  ApiResult _handleException(String message) {
    log.e("====== API Error ======\n$message");
    return Response(statusCode: 400, body: {}, statusText: message);
  }

  /// ---------------- Logging -------------------------------------
  void _logRequest(String url, String method, [dynamic body]) {
    log.i("====== API [$method] Request ======\nURL: $url");
    if (body != null) {
      if (body is Map) {
        try {
          const encoder = JsonEncoder.withIndent('  ');
          log.d("Request Body:\n${encoder.convert(body)}");
        } catch (_) {
          log.d("Request Body:\n$body");
        }
      } else {
        log.d("Request Body:\n$body");
      }
    }
  }

  // ======================== HTTP METHODS ========================

  Future<ApiResult> get({
    required String url,
    bool isBasic = false,
    bool isToken = false, // <-- NEW: add token option
    Map<String, String>? customHeaders,
  }) async {
    // Get headers properly
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken, // <-- pass token flag
      customHeaders: customHeaders,
    );

    log.d("GET Headers: $headers"); // Debug: check if token is included

    return safeRequest(
      () async => http.get(Uri.parse(url), headers: headers),
      url: url,
      method: "GET",
    );
  }

  Future<ApiResult> post({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    // ✅ Get headers properly
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    log.d("POST Headers: $headers"); // Debug: check if token is included

    return safeRequest(
      () async => http.post(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "POST",
      requestBody: body,
    );
  }

  Future<ApiResult> put({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false, // <-- token support
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    return safeRequest(
      () async => http.put(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "PUT",
      requestBody: body,
    );
  }

  Future<ApiResult> patch({
    required String url,
    Map<String, dynamic>? body,
    bool isBasic = false,
    bool isToken = false, // <-- token support
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    return safeRequest(
      () async => http.patch(
        Uri.parse(url),
        body: jsonEncode(body ?? {}),
        headers: headers,
      ),
      url: url,
      method: "PATCH",
      requestBody: body,
    );
  }

  Future<ApiResult> delete({
    required String url,
    Map<String, dynamic>? body, // optional body
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    final headers = await _headers(
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );

    // Use http.Request to send DELETE with body
    return safeRequest(
      () async {
        final request = http.Request("DELETE", Uri.parse(url))
          ..headers.addAll(headers)
          ..body = jsonEncode(body ?? {}); // attach body if provided

        final streamedResponse = await request.send().timeout(defaultTimeout);
        return http.Response.fromStream(streamedResponse);
      },
      url: url,
      method: "DELETE",
      requestBody: body,
    );
  }

  // ================================================================
  //                      MULTIPART Upload (Enhanced Logging)
  // ================================================================
  Future<ApiResult> multipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFileData> files,
    String method = "POST",
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      _logRequest(url, "MULTIPART $method");

      final request = http.MultipartRequest(method, Uri.parse(url));

      // Add headers
      final headers = await _headers(
        isBasic: isBasic,
        isToken: isToken,
        customHeaders: customHeaders,
      );
      request.headers.addAll(headers);
      log.i("Request Headers: $headers");

      // Add fields
      request.fields.addAll(fields);
      log.i("Request Fields: $fields");

      // Add files
      for (var file in files) {
        final fileObj = File(file.path);

        if (!fileObj.existsSync()) {
          log.e("File not found: ${file.path}");
          continue; // skip missing files
        }

        final mimeTypeData =
            (lookupMimeType(file.path)?.split('/') ??
            ['application', 'octet-stream']);
        final contentType = MediaType(mimeTypeData[0], mimeTypeData[1]);

        log.i(
          "Adding file -> Key: ${file.key}, Path: ${file.path}, MIME: ${mimeTypeData.join('/')}, Size: ${fileObj.lengthSync()} bytes",
        );

        request.files.add(
          await http.MultipartFile.fromPath(
            file.key,
            file.path,
            contentType: contentType,
          ),
        );
      }

      // Send request with timeout
      final streamed = await request.send().timeout(ApiClient.defaultTimeout);

      // Convert streamed response to http.Response
      final response = await http.Response.fromStream(streamed);

      log.i("Multipart Response Status: ${response.statusCode}");
      log.i("Multipart Response Body: ${response.body}");

      return _handleResponse(response);
    } catch (e) {
      log.e("Multipart Error: $e");
      return _handleException("Multipart Error: $e");
    }
  }

  Future<ApiResult> postMultipart({
    required String url,
    required Map<String, String> fields,
    required List<MultipartFileData> files,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    return multipart(
      url: url,
      fields: fields,
      files: files,
      isBasic: isBasic,
      isToken: isToken,
      customHeaders: customHeaders,
    );
  }

  // ... your existing _headers, _logRequest, _handleResponse, etc.

  /// ---------------- PATCH with multipart & token -----------------
  Future<ApiResult> patchWithMultipart({
    required String url,
    required Map<String, String> fields,
    File? imageFile,
    bool isBasic = false,
    bool isToken = false,
    Map<String, String>? customHeaders,
  }) async {
    try {
      _logRequest(url, "MULTIPART PATCH");

      final request = http.MultipartRequest("PATCH", Uri.parse(url));

      final headers = await _headers(
        isBasic: isBasic,
        isToken: isToken,
        customHeaders: customHeaders,
      );
      request.headers.addAll(headers);

      request.fields.addAll(fields);

      if (imageFile != null && imageFile.existsSync()) {
        final mimeTypeData =
            (lookupMimeType(imageFile.path)?.split('/') ??
            ['application', 'octet-stream']);

        request.files.add(
          await http.MultipartFile.fromPath(
            "insurance_Photo", // ✅ correct key
            imageFile.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      final streamed = await request.send().timeout(defaultTimeout);
      final response = await http.Response.fromStream(streamed);

      return _handleResponse(response);
    } catch (e) {
      return _handleException("PATCH Multipart Error: $e");
    }
  }

  Future<ApiResult> uploadMedicalImage({
    required String url,
    required String imageKey, // medical_mySelf_image / medical_family_image
    required File imageFile,
    bool isToken = true,
  }) async {
    return multipart(
      url: url,
      fields: {},
      files: [MultipartFileData(key: imageKey, path: imageFile.path)],
      customHeaders: isToken
          ? {
              "Authorization":
                  "Bearer ${await SharePrefsHelper.getToken() ?? ""}",
            }
          : null,
    );
  }

  Future<ApiResult> getMedicalImages({
    required String url,
    bool isToken = true,
  }) async {
    return get(url: url, isToken: isToken);
  }

  Future<ApiResult> removeMedicalImage({
    required String url,
    required Map<String, dynamic> body,
    bool isToken = true,
  }) async {
    return patch(url: url, body: body, isToken: isToken);
  }
}

/// ================= Multipart File Model ========================
class MultipartFileData {
  final String key;
  final String path;

  MultipartFileData({required this.key, required this.path});

  String get mimeType => lookupMimeType(path) ?? "application/octet-stream";
}
