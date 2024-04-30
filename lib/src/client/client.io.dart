import 'dart:io';
import 'dart:typed_data';

import '../blob.dart';
import '../formdata.dart';
import '../headers.dart';
import '../request.dart';
import '../request_destination.dart';
import '../request_redirect.dart';
import '../response.dart';
import '../response_type.dart';
import '../types.dart';
import '../url.dart';
import 'client.stub.dart' as stub;

class Client implements stub.Client {
  final HttpClient _client = HttpClient();

  @override
  Future<Response> send(Request request, {bool keepalive = false}) async {
    final ioRequest =
        await _client.openUrl(request.method, Uri.parse(request.url));
    final blob = await request.blob();

    ioRequest.followRedirects = request.redirect == RequestRedirect.follow;
    ioRequest.persistentConnection = keepalive;
    ioRequest.contentLength = parseContentLength(request.headers, blob);

    // Remove Content-Length header
    request.headers.delete('content-length');

    // Set default user-agent
    if (!request.headers.has('user-agent')) {
      request.headers.set('user-agent', 'webfetch');
    }

    // Default headers
    ioRequest.headers.forEach((name, values) {
      if (request.headers.has(name)) return;
      if (name.toLowerCase() == 'user-agent') return;

      for (final value in values) {
        request.headers.append(name, value);
      }
    });
    ioRequest.headers.clear();

    // Apply headers
    request.headers.forEach((value, name, parent) {
      ioRequest.headers.add(name, value);
    });
    ioRequest.applySecOrOtherHeaders(request);

    // Apply `Set-Cookie`
    for (final cookie in request.headers.getSetCookie()) {
      ioRequest.headers.add('set-cookie', cookie);
    }

    // Sets body
    await ioRequest.addStream(blob.stream());

    // Send request
    final ioResponse = await ioRequest.close();
    final stream =
        ioResponse.map<Uint8List>((chunk) => Uint8List.fromList(chunk));

    final responseHeaders = Headers();
    ioResponse.headers.forEach((name, values) {
      for (final value in values) {
        responseHeaders.append(name, value);
      }
    });

    final innerResponse = Response(
      stream,
      status: ioResponse.statusCode,
      statusText: ioResponse.reasonPhrase,
      headers: responseHeaders,
    );
    final response = _InnerResponse(request, innerResponse, ioResponse);

    if (response.redirected && request.redirect == RequestRedirect.error) {
      throw response;
    }

    return response;
  }
}

extension on Client {
  int parseContentLength(Headers headers, Blob blob) {
    if (headers.has('content-length')) {
      try {
        return int.parse(headers.get('content-length')!);
      } catch (_) {
        return blob.size;
      }
    }

    return blob.size;
  }
}

extension on HttpClientRequest {
  void applySecOrOtherHeaders(Request request) {
    // fetch dest
    if (headers.value('sec-fetch-dest') == null &&
        request.destination != RequestDestination.default_) {
      headers.set('sec-fetch-dest', request.destination.value);
    }

    // fetch mode
    if (headers.value('sec-fetch-mode') == null) {
      headers.set('sec-fetch-mode', request.mode.value);
    }

    // fetch site
    if (headers.value('sec-fetch-site') == null) {
      headers.set('sec-fetch-site', request.referrerPolicy.value);
    }

    // fetch user
    if (headers.value('sec-fetch-user') == null) {
      headers.set('sec-fetch-user', '?0');
    }

    // Referer
    if (headers.value('referer') == null) {
      headers.set('referer', request.referrer);
    }
  }
}

class _InnerResponse implements Response {
  final Request _innerRequest;
  final Response _innerResponse;
  final HttpClientResponse _ioResponse;

  const _InnerResponse(
      this._innerRequest, this._innerResponse, this._ioResponse);

  @override
  Stream<Uint8List>? get body => _innerResponse.body;

  @override
  Headers get headers => _innerResponse.headers;

  @override
  bool get redirected => _ioResponse.redirects.isNotEmpty;

  @override
  int get status => _ioResponse.statusCode;

  @override
  ResponseType get type => _innerResponse.type;

  @override
  String get url {
    if (_ioResponse.redirects.isNotEmpty) {
      return URL(_ioResponse.redirects.last.location, _innerRequest.url)
          .toString();
    }

    return _innerRequest.url;
  }

  @override
  Future<ArrayBuffer> arrayBuffer() => _innerResponse.arrayBuffer();

  @override
  Future<Blob> blob() => _innerResponse.blob();

  @override
  bool get bodyUsed => _innerResponse.bodyUsed;

  @override
  Future<FormData> formData() => _innerResponse.formData();

  @override
  Future<Object> json() => _innerResponse.json();

  @override
  bool get ok => _innerResponse.ok;

  @override
  String get statusText => _innerResponse.statusText;

  @override
  Future<String> text() => _innerResponse.text();

  @override
  Response clone() =>
      _InnerResponse(_innerRequest, _innerResponse.clone(), _ioResponse);
}
