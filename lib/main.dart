import "package:flutter/material.dart";

import "listing.dart";

void main() => runApp(Butterfree());

class Butterfree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Butterfree",
        theme: ThemeData(primarySwatch: Colors.pink),
        home: GestureDetector(
          child: ButterfreeHome(),
          onTap: FocusScope.of(context).unfocus,
        ));
  }
}

class ButterfreeHome extends StatefulWidget {
  @override
  _ButterfreeHomeState createState() => _ButterfreeHomeState();
}

class _ButterfreeHomeState extends State<ButterfreeHome> {
  bool _onList = true;

  void swapScreenCallback() async {
    await setState(() => _onList = !_onList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new ButterfreeAppBar(),
      // TODO null will be the other view
      body: _onList ? new UploadedListing() : null,
      floatingActionButton: new ScreenFloater(swapScreenCallback),
    );
  }
}

class ButterfreeAppBar extends StatelessWidget implements PreferredSizeWidget {
  String _title = "Butterfree";
  double _height = 42;

  @override
  Size get preferredSize => Size.fromHeight(_height);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      title: Text(_title),
    );
  }
}

class ScreenFloater extends StatefulWidget {
  Function() swapScreenCallback;

  ScreenFloater(this.swapScreenCallback);

  @override
  _ScreenFloaterState createState() => _ScreenFloaterState();
}

class _ScreenFloaterState extends State<ScreenFloater> {
  final List<IconData> screenIcons = <IconData>[Icons.add, Icons.menu];
  bool _onList = true;

  void swapScreen() async {
    await widget.swapScreenCallback();
    await setState(() => _onList = !_onList);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: swapScreen,
      child: Icon(screenIcons[_onList ? 0 : 1]),
    );
  }
}
