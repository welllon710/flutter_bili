import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class CardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double cardHeight = 270;

  @override
  double get minExtent => cardHeight;

  @override
  double get maxExtent => cardHeight;

  _ImageText(String image, String text) {
    return Row(
      children: [
        Image.asset('assets/images/$image.png', width: 15, height: 15),
        SizedBox(width: 3),
        Text(
          '$text',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: cardHeight,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo_ruiji.png',
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '欢迎来到苍穹外卖',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ImageText('length', '距离1.5km'),
                                _ImageText('money', '配送费6元'),
                                _ImageText('time', '预计时长12min'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('苍穹餐厅为顾客打造专业的大众化美食外送餐饮'),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              Text('北京市朝阳区新街大道一号楼8层'),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Icon(Icons.favorite)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: CardHeaderDelegate()),
          SliverFillRemaining(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// 左边分类
                      Material(
                        color: Colors.grey[200],
                        child: SizedBox(
                          width: 130,
                          child: _buildCategoryList(),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.white,
                          child: _buildProductList(),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCart() {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 100,
      child: Row(
        children: [
          _buildBadge(),
          SizedBox(width: 10),
          Text("￥3.19", style: TextStyle(color: Colors.red, fontSize: 30)),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.yellow,
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Text(
                '去结算',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Obx(() {
      if (controller.categoryList.isEmpty) {
        return Center(
          child: Text(
            '暂无分类',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.categoryList.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool selected = index == controller.selected.value;
            return GestureDetector(
              onTap: () {
                controller.setSelected(
                  index,
                  controller.categoryList[index].id,
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: selected ? Colors.blue : Colors.grey[200],
                    ),
                    height: 50,
                    child: Center(
                      child: Text('${controller.categoryList[index].name}'),
                    ),
                  ),
                  // 只有选中时才显示角标
                  if (selected)
                    Positioned(
                      left: 120,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white, // 右侧内容区背景色
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildProductList() {
    return Obx(() {
      if (controller.products.isEmpty) {
        return Center(
          child: Text(
            '暂无商品',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          var product = controller.products[index];
          // flavors 已在模型中处理为非空列表，直接判断是否为空
          var isFlavours = product.flavors.isNotEmpty;
          print('isFlavours: ${product.flavors}');
          return Container(
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo_ruiji.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '未命名商品',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        product.description ?? '暂无描述',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text("月销量: 0", style: TextStyle(fontSize: 12)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "￥${product.price?.toString() ?? '0.00'}",
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.yellow,
                              minimumSize: Size.zero, // 去掉最小尺寸
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child:
                                  isFlavours
                                      ? Text(
                                        '选择规格',
                                        style: TextStyle(color: Colors.black),
                                      )
                                      : Icon(Icons.add, size: 20),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildBadge() {
    return Stack(
      children: [
        Image.asset('assets/images/btn_waiter_sel.png', width: 70, height: 70),
        Positioned(
          top: 10,
          right: 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
