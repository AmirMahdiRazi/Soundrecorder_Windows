import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'data.dart';
import 'package:flutter/services.dart';
import 'dropdowntext.dart';

class Window_recorder extends StatefulWidget {
  const Window_recorder({Key? key}) : super(key: key);

  @override
  State<Window_recorder> createState() => _Window_recorderState();
}

class _Window_recorderState extends State<Window_recorder> {
  bool _btnActiveSTDN = false;
  final record = Record();
  late bool _isRecording;
  IconData _status = Icons.mic;
  String directory_path = Directory.current.parent.path;
  late String _txt = 'none';
  final controllerStdNum = TextEditingController();
  Color colour = Colors.lightBlue;
  bool _visable = false;
  @override
  void initState() {
    getDataLastFile();
    super.initState();
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  void toggle() async {
    setState(() {});
    _isRecording = await record.isRecording();
    _isRecording ? stop_record() : start_record();
    // Future.delayed(Duration(seconds: 2));
  }

  void stop_record() async {
    await record.stop().then((value) {
      setState(() {});
    });
    _txt = 'Recorder is stopped';
    _status = Icons.mic;
    next();
  }

  void start_record() async {
    Directory directory = Directory('${directory_path}/$data_number');
    bool _isExists = await directory.exists();
    if (_isExists) {
      String file_name = '$data_number' + '_' + '$data_count' + '.wav';
      record
          .start(
              path: p.join('$directory_path/$data_number', file_name),
              encoder: AudioEncoder.wav)
          .then((value) {
        setState(() {});
      });
      _txt = 'Recording in progress';
      _status = Icons.stop;
    } else {
      bool temp = await create_directory();
      if (temp) {
        String file_name = '$data_number' + '_' + '$data_count' + '.wav';
        record
            .start(
                path: p.join('$directory_path/$data_number', file_name),
                encoder: AudioEncoder.wav)
            .then((value) {
          setState(() {});
        });
        _txt = 'Recording in progress';
        _status = Icons.stop;
      }
    }
  }

  void next() {
    counter_count++;
    if (counter_count <= 19) data_count = kcount[counter_count];

    if (counter_count == 20) {
      counter_count = 0;
      data_count = kcount[0];
      if (counter_number <= knumber.length - 2) {
        counter_number++;
        data_number = knumber[counter_number];
        if (data_number != null) create_directory();
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('ذخیره 900 با تکرار 20'),
            content: const Text('دیتاست شما 900 را با تکرار 20 ذخیره کرد'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'End'),
                child: const Text('فهمیدم'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<bool> create_directory() async {
    var direct =
        await Directory('$directory_path/$data_number').create(recursive: true);
    bool _isExi = await direct.exists();
    bool res;
    res = _isExi ? true : false;
    return res;
  }

  void saveOnFile() async {
    std_number = controllerStdNum.text;
    var directory =
        await Directory('${directory_path}/${std_number}\'s Semnan Recorder/')
            .create(recursive: true);
    bool _isExists = await directory.exists();
    var file = File('$directory_path/info.txt');
    file.writeAsString('$std_number');
    if (_isExists) {
      directory_path = '${directory_path}\\${std_number}\'s Semnan Recorder';
      colour = Colors.green.shade600;
      _visable = true;
    }
    setState(() {});
  }

  void getDataLastFile() async {
    var location = File('$directory_path/info.txt');
    var exi = await location.exists();
    if (exi) {
      var contents = await location.readAsString();
      if (contents != '') {
        var out = contents.split('\n');
        std_number = out[0];

        controllerStdNum.text = std_number;
      } else {
        return;
      }
    }
    String pdfDirectory = '${directory_path}/${std_number}\'s Semnan Recorder';
    final myDir = Directory(pdfDirectory);
    bool _exi_directory = await Directory('$pdfDirectory').exists();
    dynamic _folders;
    if (_exi_directory) {
      try {
        _folders = myDir.listSync(recursive: true, followLinks: false);
      } catch (e) {
        print(e);
      }
    } else {
      return;
    }
    directory_path = pdfDirectory;
    List temp = [];
    String t1 = '';
    _visable = true;
    _btnActiveSTDN = true;
    colour = Colors.green.shade600;
    setState(() {});
    _btnActiveSTDN = true;
    for (var i in _folders) {
      t1 = (i.toString().split('\\').last);
      temp.add(t1.replaceAll('\'', ''));
    }
    List list_exist_file = temp;
    list_exist_file = list_exist_file.reversed.toList();
    if (list_exist_file.isNotEmpty) {
      if (list_exist_file[0].split('_').length > 1) {
        data_number = list_exist_file[0].split('_')[0];
        for (int j = 0; j < knumber.length; j++) {
          if (data_number == knumber[j]) {
            counter_number = j;
            break;
          }
        }
        data_count = list_exist_file[0].split('_')[1].split('.')[0];
        for (int j = 0; j < kcount.length; j++) {
          if (data_count == kcount[j]) {
            counter_count = j;
          }
        }
      } else {
        data_number = list_exist_file[0].toString();
        for (int j = 0; j < knumber.length; j++) {
          if (data_number == knumber[j]) {
            counter_number = j;
          }
        }
        data_count = '1';
        counter_count = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 250),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controllerStdNum,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      maxLines: 1,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      textInputAction: TextInputAction.next,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'شماره دانشجویی'),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        setState(() {
                          _btnActiveSTDN = value.length >= 10 ? true : false;
                        });
                      },
                    ),
                    RaisedButton(
                      color: colour,
                      onPressed: _btnActiveSTDN ? saveOnFile : null,
                      child: Text('Save!'),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: _visable,
                child: Expanded(
                  child: Column(
                    children: [
                      DropdownText(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(30),
                              ),
                              onPressed: toggle,
                              child: Icon(
                                _status,
                                color: Colors.black87,
                                size: 35.0,
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Text(_txt),
                          ],
                        ),
                      ),
                      Container(
                        child: Text('path: $directory_path'),
                        height: 50.0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
