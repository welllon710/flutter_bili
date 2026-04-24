import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/data/models/hot_search_model.dart';
import 'package:get_demo/app/data/repositories/searchRepo.dart';

class SearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final SearchRepo searchRepo = Get.find<SearchRepo>();
  final RxList<HotSearchItem> hotList = <HotSearchItem>[].obs;
  final RxBool isRefreshing = false.obs;
  final RxDouble refreshTurns = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initKeyword();
    refreshHotList();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  Future<void> refreshHotList() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    refreshTurns.value += 1;

    try {
      final HotSearchModel val = await searchRepo.searchHotList();
      hotList.value = val.list ?? [];
    } finally {
      isRefreshing.value = false;
    }
  }

  void setSelectedKeyword(String s) {
    searchController.value = TextEditingValue(
      text: s,
      selection: TextSelection.collapsed(offset: s.length),
    );
    if (searchFocusNode.canRequestFocus) {
      searchFocusNode.requestFocus();
    }
  }

  void _initKeyword() {
    final dynamic args = Get.arguments;
    String keyword = '';

    if (args is Map) {
      keyword = (args['defaultKeyword'] ?? args['keyword'] ?? '').toString();
    }

    if (keyword.isEmpty) {
      keyword = Get.parameters['defaultKeyword'] ?? Get.parameters['keyword'] ?? '';
    }

    if (keyword.isEmpty) return;

    searchController.value = TextEditingValue(
      text: keyword,
      selection: TextSelection.collapsed(offset: keyword.length),
    );
  }
}
