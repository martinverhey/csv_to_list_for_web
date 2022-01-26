import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({Key? key}) : super(key: key);

  @override
  _AddUsersPageState createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  late List<List<dynamic>> employeeData;

  Future _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['csv']);
    if (result != null) {
      //decode bytes back to utf8
      final bytes = utf8.decode((result.files.first.bytes)!.toList());
      setState(() {
        //from the csv plugin
        employeeData = CsvToListConverter().convert(bytes);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    employeeData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CSV TO LIST'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  child: Text(
                    "CSV To List",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _openFileExplorer,
                ),
              ),
            ),
            Text("employeeData.length" +
                ((employeeData.isNotEmpty)
                    ? employeeData.length.toString()
                    : ' is empty for now')),
            Text("employeeData.first.length" +
                ((employeeData.isNotEmpty)
                    ? employeeData.first.length.toString()
                    : ' is empty for now')),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: employeeData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: employeeData[index].map((e) {
                            return Text(e.toString());
                          }).toList(),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
