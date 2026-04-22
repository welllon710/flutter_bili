import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_demo/app/modules/search/controllers/search_controller.dart'
    as search;

class SearchView extends GetView<search.SearchController> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    hintText: '搜索视频、UP 主、专栏',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '搜索  ',
                style: TextStyle(color: colorScheme.primary, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text('SearchView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
