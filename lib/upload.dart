import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:file_picker/file_picker.dart" as file;

class UploadPanel extends StatefulWidget {
  @override
  _UploadPanelState createState() => _UploadPanelState();
}

class _UploadPanelState extends State<UploadPanel> {
  final Map<String, String> _textFieldDefaults = {
    "filename": "",
    "host": "http://gastrodon.io/file/",
    "secret": "secret_key",
  };

  Map<String, ButtonConfig> _buttonConfigs = {
    "file": ButtonConfig(
      key: "file",
    ),
    "upload": ButtonConfig(
      key: "upload",
    ),
  };

  String _filepath;
  Map<String, Function()> _buttonHandlers = {};
  Map<String, String> _buttonLabels = {};
  Map<String, String> _textFieldValues = {};

  void recieveTextFieldValue(String target, String value) async {
    _textFieldValues[target] = value;
  }

  void recieveFilepath() async {
    String selected;

    try {
      // TODO check for permissions first,
      // or this will crash if they are unset or disallowed
      selected = await file.FilePicker.getFilePath(type: file.FileType.any);
    } on PlatformException catch (err) {
      // TODO tell somebody, you spud
      selected = null;
    }

    setState(() {
      _filepath = selected;
      _buttonConfigs["file"].label = (selected ?? "file").split("/").last;
      _buttonConfigs["upload"].handler =
          (_filepath == null ? null : uploadFile);
    });
  }

  void uploadFile() async {
    // TODO to be implemented
    print("uploadFile");
  }

  _UploadPanelState() {
    _buttonConfigs["file"].handler = recieveFilepath;
    _buttonConfigs["upload"].handler = null;
  }

  double maxButtonWidth(double padding) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int count = _buttonConfigs.length;
    return (screenWidth / count) - (2 * padding * count);
  }

  List<Widget> get buttons {
    final double horizontalPadding = 4;

    return _buttonConfigs.keys
        .map((key) => _buttonConfigs[key].built)
        .map((it) => Container(
              child: it,
              constraints: BoxConstraints(
                maxWidth: maxButtonWidth(horizontalPadding),
              ),
            ))
        .map((it) => Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: it,
            ))
        .toList(growable: false);
  }

  List<Widget> get textFields {
    return _textFieldDefaults.keys
        .map((key) => OptionalText(
              target: key,
              value: _textFieldDefaults[key],
              callback: recieveTextFieldValue,
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...textFields,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
        )
      ],
    );
  }
}

class OptionalText extends StatefulWidget {
  String value;
  String target;
  Function(String, String) callback;

  OptionalText({
    @required String this.value,
    @required String this.target,
    @required Function(String, String) this.callback,
  });

  @override
  _OptionalTextState createState() => _OptionalTextState();
}

class _OptionalTextState extends State<OptionalText> {
  bool _checked = false;
  String _value = "";
  TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.text = widget.value;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void checkboxChanged(bool checked) async {
    await setState(() => _checked = checked);

    String settable = checked ? _value : widget.value;
    _textController.text = settable;
  }

  void textFieldChanged(String value) async {
    _value = value;
    if (widget.callback != null) {
      await widget.callback(widget.target, value);
    }
  }

  TextField get textFieldBuild {
    //  TODO subclass TextField to accept
    //  an onEnabled callback to request focus when enabled

    return TextField(
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      style: TextStyle(color: _checked ? Colors.black : Colors.grey),
      enabled: _checked,
      controller: _textController,
      onChanged: textFieldChanged,
    );
  }

  Checkbox get checkboxBuilt {
    return Checkbox(
      value: _checked,
      onChanged: checkboxChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: <Widget>[
          checkboxBuilt,
          Flexible(child: textFieldBuild),
        ],
      ),
    );
  }
}

class ButtonConfig {
  String key, label;
  void Function() handler;

  ButtonConfig({
    @required this.key,
    this.label,
    this.handler,
  });

  RaisedButton get built {
    return RaisedButton(
      child: Text(
        label ?? key,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onPressed: handler,
    );
  }
}
