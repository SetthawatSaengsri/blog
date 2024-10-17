// data_list_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataListPage extends StatefulWidget {
  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _dataList = prefs.getStringList('dataList') ?? [];
    });
  }

  _addData(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dataList.add(data);
    await prefs.setStringList('dataList', _dataList);
    setState(() {});
  }

  _removeData(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dataList.removeAt(index);
    await prefs.setStringList('dataList', _dataList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการข้อมูล"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_dataList[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeData(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddDataDialog();
              },
              child: Text("เพิ่มข้อมูล"),
            ),
          ),
        ],
      ),
    );
  }

  _showAddDataDialog() {
    TextEditingController dataController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("เพิ่มข้อมูลใหม่"),
          content: TextField(
            controller: dataController,
            decoration: InputDecoration(hintText: "กรอกข้อมูล"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (dataController.text.isNotEmpty) {
                  _addData(dataController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text("เพิ่ม"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ยกเลิก"),
            ),
          ],
        );
      },
    );
  }
}
