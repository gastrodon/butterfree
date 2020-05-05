import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:file_picker/file_picker.dart" as file;

import "utility.dart" as util;

class UploadPanel extends StatefulWidget {
  @override
  _UploadPanelState createState() => _UploadPanelState();
}

class _UploadPanelState extends State<UploadPanel> {
  String _filepath;
  Map<String, ButtonConfig> _buttonConfigs = {
    "file": ButtonConfig(
      key: "file",
    ),
    "upload": ButtonConfig(
      key: "upload",
    ),
  };
  Map<String, OptionalTextConfig> _optionalTextConfigs = {
    "filename": OptionalTextConfig(
      target: "filename",
    ),
    "host": OptionalTextConfig(
      target: "host",
      defaultValue: "http://gastrodon.io/",
    ),
    "secret": OptionalTextConfig(
      target: "secret",
      defaultValue: "secret_key",
    ),
  };

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
    print(_optionalTextConfigs.values.map((it) => it.value).toList());
    util.ferrothornUpload(
      "http://gastrodon.io/file/",
      "secret_key",
      "",
      _filepath,
    );
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
    return _optionalTextConfigs.values
        .map((value) => value.built)
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
  Function(String) textChanged;
  Function(bool) checkboxChanged;

  OptionalText({
    @required String this.value,
    @required String this.target,
    @required Function(String) this.textChanged,
    @required Function(bool) this.checkboxChanged,
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

    await widget.checkboxChanged(checked);
  }

  void textChanged(String value) async {
    _value = value;

    await widget.textChanged(value);
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
      onChanged: textChanged,
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

class OptionalTextConfig {
  String target, defaultValue;
  String _value = "";
  bool _enabled = false;

  OptionalTextConfig({
    @required this.target,
    this.defaultValue,
  }) {
    defaultValue = defaultValue ?? "";
  }

  OptionalText get built {
    return OptionalText(
      target: target,
      value: defaultValue,
      textChanged: textChanged,
      checkboxChanged: checkboxChanged,
    );
  }

  void textChanged(String value) async {
    _value = value;
  }

  void checkboxChanged(bool checked) async {
    _enabled = checked;
  }

  String get value {
    return _enabled ? _value : defaultValue;
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
