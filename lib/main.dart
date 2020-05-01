import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:file_picker/file_picker.dart";

String file_path;

void main() => runApp(Butterfree());

class Butterfree extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: "Butterfree",
            theme: ThemeData(primarySwatch: Colors.pink),
            home: ButterfreeHome(),
        );
    }
}

class ButterfreeHome extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold (
            body: Center(
                child: new FPSelector(),
            ),
        );
    }
}

class FPSelector extends StatefulWidget {
    @override
    _FPSelectorState createState() => _FPSelectorState();
}

class _FPSelectorState extends State<FPSelector> {
    String path;

    void openExplorer() async {
        String selected;
        try {
            selected = await FilePicker.getFilePath();
        } on PlatformException catch (_) { }
        setState(() => this.path = selected);
    }

    @override
    Widget build(BuildContext context) {
        return RaisedButton(
            child: Text(this.path ?? "no file"),
            onPressed: this.openExplorer,
        );
    }
}
