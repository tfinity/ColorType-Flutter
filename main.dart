import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  final inputData = TextEditingController();
  bool singleColor = false;
  bool seqCheck = false;
  bool sequence = false;
  var setIndex = 0;

  Color _customColor;

  // ignore: deprecated_member_use
  List<Widget> _list = List<Widget>();
  // ignore: deprecated_member_use
  List<Color> selectedColors = List<Color>();

  List<Widget> _color = List<Widget>();

  Widget creatCard(Color color) {
    if (!singleColor) {
      selectedColors.clear();
      _color.removeRange(1, _color.length);
    }
    selectedColors.add(color);
    Key key = UniqueKey();
    return Card(
      key: key,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: new InkWell(
        onTap: () {
          _color.removeWhere((element) => element.key == key);
          selectedColors.remove(color);
          setState(() {});
        },
        child: Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(0),
        ),
      ),
    );
  }

  @override
  void initState() {
    Card card;
    card = new Card(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Choose Color"),
                content: new ColorPicker(
                  onChanged: (value) {
                    setState(() {
                      _customColor = value;
                    });
                  },
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel")),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      setState(() {
                        _color.add(creatCard(_customColor));
                      });
                    },
                    child: Text("Set"),
                    style: ElevatedButton.styleFrom(primary: _customColor),
                  ),
                ],
              );
            });
      },
      child: Container(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        height: 40,
        width: 40,
        padding: EdgeInsets.all(0),
      ),
    ));
    _color.add(card);
  }

  Widget create(String text) {
    if (sequence) {
      var rng = new Random();
      int index = rng.nextInt(selectedColors.length);
      Text child = new Text(text,
          style: TextStyle(
            color: selectedColors.elementAt(
                index), //Color(colorSet(selectedColors.elementAt(index))),
            fontSize: 30.0,
          ));
      return child;
    } else {
      if (setIndex >= selectedColors.length) setIndex = 0;
      Text child = new Text(text,
          style: TextStyle(
            color: selectedColors.elementAt(
                setIndex), //Color(colorSet(selectedColors.elementAt(setIndex))),
            fontSize: 30.0,
          ));
      setIndex++;
      return child;
    }
  }

  void _onsubmit(String text) {
    setState(() {
      if (selectedColors.isNotEmpty) {
        _list.clear();
        for (int i = 0; i < text.length; i++) {
          _list.add(create(text[i]));
        }
      }
    });
  }

  String sColor = 'Single';
  String seqColor = 'Sequence';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'ColorType',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showAboutDialog(context: context);
              })
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$sColor Color',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                  value: singleColor,
                  onChanged: (value) {
                    setState(() {
                      selectedColors.clear();
                      _color.removeRange(1, _color.length);
                      singleColor = value;
                      seqCheck = !seqCheck;
                      if (!singleColor)
                        sColor = 'Single';
                      else
                        sColor = 'Multi';
                    });
                  }),
              Visibility(
                visible: seqCheck,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$seqColor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                        value: sequence,
                        onChanged: (value) {
                          setState(() {
                            sequence = value;
                            if (!sequence)
                              seqColor = 'Sequence';
                            else
                              seqColor = 'Random';
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
          Wrap(children: _color),
          Expanded(
            child: SingleChildScrollView(child: Wrap(children: _list)),
          ),
          Container(
            child: TextField(
              controller: inputData,
              decoration: InputDecoration(
                hintText: 'Hello World',
              ),
              autocorrect: true,
              keyboardType: TextInputType.text,
              maxLines: 5,
              minLines: 1,
            ),
            padding: EdgeInsets.all(0),
          ),
          ElevatedButton(
            onPressed: () {
              _onsubmit(inputData.text);
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Text('Submit'),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
