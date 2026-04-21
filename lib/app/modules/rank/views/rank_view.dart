import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rank_controller.dart';

class RankView extends GetView<RankController> {
  const RankView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RankView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RankView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
