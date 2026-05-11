import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/controller/search_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/manga_model.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(MangaSearchController());
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Khi cuộn tới cuối danh sách thì tải thêm
    scrollController.addListener(() async {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        await controller.loadMore();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    Get.delete<MangaSearchController>();
    super.dispose();
  }

  void _search() async {
    final query = textController.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();
    await controller.search(query); 
    setState(() {});
  }

  void _clear() {
    textController.clear();
    controller.clearSearch(); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        titleSpacing: 0,
        title: TextField(
          controller: textController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
          onChanged: (_) => setState(() {}),
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm truyện...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (textController.text.isNotEmpty)
            IconButton(icon: Icon(Icons.clear), onPressed: _clear),
          IconButton(icon: Icon(Icons.search), onPressed: _search),
        ],
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    // Đang tải
    if (controller.isSearching) {
      return Center(child: CircularProgressIndicator());
    }

    // Chưa tìm lần nào
    if (controller.currentQuery.isEmpty) {
      return _buildHint();
    }

    // Tìm rồi nhưng không có kết quả
    if (controller.searchResults.isEmpty) {
      return _buildNoResult();
    }

    // Có kết quả
    return _buildResultList();
  }

  Widget _buildHint() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          SizedBox(height: 16),
          Text('Tìm kiếm truyện bạn yêu thích',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả\ncho "${controller.currentQuery}"',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    final results = controller.searchResults;
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.all(8),
      itemCount: results.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) => _SearchResultCard(manga: results[index]),
    );
  }
}

class _SearchResultCard extends StatefulWidget {
  final MangaModel manga;
  _SearchResultCard({required this.manga});

  @override
  State<_SearchResultCard> createState() => _SearchResultCardState();
}

// AutomaticKeepAliveClientMixin để không bị load lại khi cuộn khuất màn hình
class _SearchResultCardState extends State<_SearchResultCard> with AutomaticKeepAliveClientMixin {
  late Future<dynamic> _detailFuture;

  @override
  void initState() {
    super.initState();
    final mangaController = Get.find<MangaController>();
    // gọi API 1 lần lúc khởi tạo và lưu vào biến
    _detailFuture = mangaController.fetchMangaDetail(widget.manga.slug);
  }

  //giữ lại trạng thái khi cuộn màn hình
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {
        // TODO: Chuyển sang trang chi tiết truyện
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa truyện
            Container(
              margin: EdgeInsets.all(8),
              width: 120,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(mangaResources.imageBaseUrl + widget.manga.thumbUrl),
                ),
              ),
            ),
            // Thông tin truyện
            Expanded(
              child: FutureBuilder(
                future: _detailFuture, // Truyền biến Future đã lưu ở initState vào đây
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }

                  final detail = snapshot.data!;
                  final updatedAt = DateTime.parse(detail.updatedAt);

                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên truyện
                        Text(widget.manga.title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        // Số chương
                        if (detail.chapters.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text('Latest chapter ${detail.chapters.length}',
                                style: TextStyle(fontSize: 13)),
                          ),
                        // Mô tả (bỏ thẻ HTML <p>)
                        Text(
                          detail.content
                              .replaceAll('<p>', '')
                              .replaceAll('</p>', ''),
                          maxLines: 3,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        // Ngày cập nhật
                        Text('${updatedAt.day}/${updatedAt.month}/${updatedAt.year}',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
