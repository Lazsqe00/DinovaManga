import 'package:dieu65130478_flutter_app/btn/controller/manga_controller.dart';
import 'package:dieu65130478_flutter_app/btn/controller/search_controller.dart';
import 'package:dieu65130478_flutter_app/btn/models/manga_resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/manga_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final MangaSearchController controller;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final RxString _inputText = ''.obs;

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MangaSearchController(), permanent: false);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _inputText.close();
    Get.delete<MangaSearchController>();
    super.dispose();
  }

  void _onSearch() {
    final query = _textController.text.trim();
    if (query.isEmpty) return;
    _focusNode.unfocus();
    setState(() => _hasSearched = true);
    controller.search(query);
  }

  void _onClear() {
    _textController.clear();
    _inputText.value = '';
    controller.clearSearch();
    setState(() => _hasSearched = false);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        titleSpacing: 0,
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          onChanged: (value) => _inputText.value = value,
          onSubmitted: (_) => _onSearch(),
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm truyện...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
        actions: [
          Obx(() {
            if (_inputText.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _onClear,
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(icon: const Icon(Icons.search), onPressed: _onSearch),
        ],
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_hasSearched && controller.searchResults.isEmpty) {
          return _buildEmptyResult(theme);
        }

        if (!_hasSearched) {
          return _buildInitialState(theme);
        }

        return _buildSearchResults(theme);
      }),
    );
  }

  Widget _buildInitialState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Tìm kiếm truyện bạn yêu thích',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResult(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả\ncho "${controller.currentQuery.value}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          controller.loadMore();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: controller.searchResults.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          if (index == controller.searchResults.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final manga = controller.searchResults[index];
          return _SearchResultCard(manga: manga);
        },
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final MangaModel manga;

  const _SearchResultCard({required this.manga});

  @override
  Widget build(BuildContext context) {
    final mangaController = Get.find<MangaController>();

    return GestureDetector(
      onTap: () {
        // TODO: Chuyển sang trang chi tiết truyện
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              height: 170,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    mangaResources.imageBaseUrl + manga.thumbUrl,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: mangaController.fetchMangaDetail(manga.slug),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const Expanded(child: SizedBox.shrink());
                }
                final data = snapshot.data!;
                final time = DateTime.parse(data.updatedAt);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manga.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (data.chapters.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Latest chapter ${data.chapters.length}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        Text(
                          data.content
                              .replaceAll("<p>", "")
                              .replaceAll("</p>", ""),
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "${time.day}/${time.month}/${time.year}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
