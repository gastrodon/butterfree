import "package:flutter/material.dart";
import "package:http/http.dart";

// TODO the ferrothorn spec will change to make the filename
// param obsolete, instead POSTing at the file's url
Future<StreamedResponse> ferrothornUpload({
  String filename,
  url,
  secret,
  filepath,
}) async {
  return await (MultipartRequest("POST", Uri.parse(url))
        ..files.add(await MultipartFile.fromPath("file", filepath))
        ..headers["Authorization"] = secret)
      .send();
}

class ApiDisplay {
  static Widget _code(int code) {
    return Container(
      child: Text("$code"),
    );
  }

  static Padding padded(Widget child) {
    return Padding(
      child: child,
      padding: EdgeInsets.symmetric(horizontal: 4),
    );
  }

  static SnackBar boxxed(int code, String content) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          _code(code),
          Text(content),
        ].map((it) => padded(it)).toList(growable: false),
      ),
    );
  }

  static Widget ok(int code, String id) {
    return boxxed(code, "id: $id");
  }

  static Widget fail(int code, String error) {
    return boxxed(code, "error: $error");
  }

  static Widget invalid(int code) {
    return boxxed(code, "non-json returned");
  }
}
