import 'package:dieu65130478_flutter_app/btn/models/managa_detail.dart';
import 'package:dieu65130478_flutter_app/btn/page/page_doc_truyen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class TimKiemChuong extends SearchDelegate {
  final MangaDetail detail;

  TimKiemChuong({required this.detail});


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Kết quả tìm kiếm
  @override
  Widget buildResults(BuildContext context) {
    return _hienThiKetQua(context);
  }

  // Gợi ý
  @override
  Widget buildSuggestions(BuildContext context) {
    return _hienThiKetQua(context);
  }


  Widget _hienThiKetQua(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Nhập số chương để tìm kiếm',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final ketQua = detail.chapters.where((chuong) {
      return chuong.chapterName.toString() == query.trim();
    }).toList();


    if (ketQua.isEmpty) {
      return Center(
        child: Text(
          'Không tìm thấy chương $query',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }


    return ListView.builder(
      itemCount: ketQua.length,
      itemBuilder: (context, index) {
        final chuong = ketQua[index];
        final viTri = detail.chapters.indexOf(chuong);

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text('Chương ${chuong.chapterName}'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              close(context, null);

              Get.to(() => PageDocTruyen(
                    chuong: chuong.chapterName,
                    chapter: chuong,
                    detail: detail,
                    currentIndex: viTri,
                  ));
            },
          ),
        );
      },
    );
  }

  @override
  TextInputType get keyboardType => TextInputType.number;

}
