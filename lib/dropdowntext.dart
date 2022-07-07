import 'package:flutter/material.dart';
import 'data.dart';

class DropdownText extends StatefulWidget {
  const DropdownText({Key? key}) : super(key: key);

  @override
  State<DropdownText> createState() => _DropdownTextState();
}

class _DropdownTextState extends State<DropdownText> {
  List<DropdownMenuItem<String>> windowsDropDown(List<String> list) {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String num in list) {
      var newItem = DropdownMenuItem(
        child: Text(
          num,
          style: TextStyle(fontSize: 20.0),
        ),
        value: num,
      );
      dropDownItems.add(newItem);
    }
    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'بار :',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  width: 50.0,
                ),
                DropdownButton(
                  iconEnabledColor: Colors.teal,
                  alignment: AlignmentDirectional.center,
                  dropdownColor: Colors.teal,
                  value: data_count,
                  items: windowsDropDown(kcount),
                  onChanged: (value) {
                    setState(
                      () {
                        data_count = value.toString();
                        for (int i = 0; i < kcount.length; i++) {
                          if (data_count == kcount[i]) {
                            counter_count = i;
                          }
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'عدد :',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(
                  width: 50.0,
                ),
                DropdownButton(
                    iconEnabledColor: Colors.teal,
                    alignment: Alignment.center,
                    dropdownColor: Colors.teal,
                    value: data_number,
                    items: windowsDropDown(knumber),
                    onChanged: (value) {
                      setState(() {
                        data_number = value.toString();
                        for (int j = 0; j < knumber.length; j++) {
                          if (data_number == knumber[j]) {
                            counter_number = j;
                          }
                        }
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
