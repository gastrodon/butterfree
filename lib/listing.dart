import "package:flutter/material.dart";

import 'package:url_launcher/url_launcher.dart' as url;

final List<String> urls = <String>[
  "foo",
  "bar",
  "favicon",
  "b_824335462_img",
];

class UploadedListing extends StatefulWidget {
  @override
  _UploadedListingState createState() => _UploadedListingState();
}

class _UploadedListingState extends State<UploadedListing> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children =
        urls.map((it) => UploadedListItem(it)).toList(growable: true);

    return ListView(
      children: children,
    );
  }
}

class UploadedListItem extends StatelessWidget {
  String id;

  UploadedListItem(this.id);

  String get file_url {
    // TODO do not keep filehost root hardcoded
    return "http://gastrodon.io/file/$id";
  }

  void open() async {
    if (await url.canLaunch(file_url)) {
      await url.launch(file_url);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onLongPress: open,
      padding: EdgeInsets.all(0),
      child: Text(
        id,
        textAlign: TextAlign.center,
        softWrap: false,
      ),
    );
  }
}
