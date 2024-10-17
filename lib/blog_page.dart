// blog_page.dart

import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  final String role;
  final String username;

  BlogPage({required this.role, required this.username});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Map<String, String>> _posts = [];

  @override
  void initState() {
    super.initState();
    _posts.add({'title': 'หมาหัวเน่า', 'content': 'เพื่อนบอกให้ผมเอาหมามาเดินเล่นในสวน ผมก็พาหมามาเดินด้วย แต่ลืมไปว่าสวนห้ามเอาหมามา เลยต้องแกล้งทำเป็นหมาเดินเอง!'});
    _posts.add({'title': 'กระเป๋าสตางค์อันเดียว', 'content': 'ตอนเช้าลืมกระเป๋าสตางค์ไว้ที่บ้าน บอกแม่ว่าไปกินข้าวเที่ยงกับเพื่อนที่ห้าง สรุปเพื่อน 5 คนลืมกระเป๋าสตางค์หมดทุกคน!'});
    _posts.add({'title': 'กางเกงตัวเก่า', 'content': 'วันแรกของการเรียนเปิดเทอมใหม่ เพื่อนทุกคนมากับเสื้อผ้าใหม่เอี่ยม ผมใส่กางเกงตัวเดิมที่แม่บอกยังใช้ได้ดีอยู่...ตั้งแต่ปีที่แล้ว!'});
    _posts.add({'title': 'ร้านกาแฟประจำ', 'content': 'ไปสั่งกาแฟร้านประจำ เจอคนชงถามว่า "จะเอาเมนูเดิมไหม?" ผมบอก "ครับ" แต่จำไม่ได้เลยว่าเมื่อวานสั่งอะไรไว้!'});
    _posts.add({'title': 'แมวตัวนี้ชอบกินปลา', 'content': 'แมวที่บ้านชอบกินปลา แต่วันนั้นให้ข้าวโพดแทน มันทำหน้างงๆ แล้วก็เดินหนีไปนั่งรอที่ตลาดปลาตรงข้ามบ้าน!'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บล็อก"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.username),
          ),
          if (widget.role == "admin")
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _createNewPost(context);
              },
            ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _posts.isEmpty
          ? Center(child: Text("ยังไม่มีบล็อก"))
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(_posts[index]['title']!),
                    subtitle: Text(_posts[index]['content']!),
                    trailing: widget.role == "admin"
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editPost(context, index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deletePost(index);
                                },
                              ),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }

  void _createNewPost(BuildContext context) {
    final _titleController = TextEditingController();
    final _contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("เพิ่มบล็อกใหม่"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(hintText: "ชื่อเรื่อง")),
              TextField(controller: _contentController, decoration: InputDecoration(hintText: "เนื้อเรื่องสั้น")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = _titleController.text;
                String content = _contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  setState(() {
                    _posts.insert(0, {'title': title, 'content': content});
                  });
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

  void _editPost(BuildContext context, int index) {
    final _titleController = TextEditingController(text: _posts[index]['title']);
    final _contentController = TextEditingController(text: _posts[index]['content']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("แก้ไขบล็อก"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(hintText: "ชื่อเรื่อง")),
              TextField(controller: _contentController, decoration: InputDecoration(hintText: "เนื้อเรื่องสั้น")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _posts[index]['title'] = _titleController.text;
                  _posts[index]['content'] = _contentController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text("แก้ไข"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ยกเลิก"),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(int index) {
    setState(() {
      _posts.removeAt(index);
    });
  }
}
