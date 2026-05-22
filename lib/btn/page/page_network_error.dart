import 'package:flutter/material.dart';

class PageNetworkError extends StatelessWidget {
  const PageNetworkError({super.key, required this.onRefresh});

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: const Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: .center,
                children: [
                  Icon(Icons.wifi_off, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Không có kết nối Internet",
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Vuốt xuống để tải lại trang",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

