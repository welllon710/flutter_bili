import 'package:get/get.dart';
import 'package:get_demo/app/data/models/category.dart';
import 'package:get_demo/app/data/models/dish.dart';
import 'package:get_demo/app/data/repositories/homeRepo.dart';

class HomeController extends GetxController {
  final HomeRepo repo = Get.find<HomeRepo>();

  var selected = 0.obs;
  var categoryList = <Category>[].obs;
  var products = <Dish>[].obs;

  var selectedFlavor = {}.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setSelected(int index, categoryId) {
    selected.value = index;
    _fetchProduct(categoryId);
  }

  // 选择口味
  selectFlavor(int index, String flavor) {
    selectedFlavor.value[index] = flavor;
    selectedFlavor.value = {...selectedFlavor.value};
  }

  void reset() {
    selectedFlavor.value = {}.obs;
  }

  addCart(Dish product) {
    print('添加购物车 ${selectedFlavor.value} ${product}');
  }

  showCart() {
    print('显示购物车');
  }

  _fetchProduct(categoryId) async {
    var list = await repo.getProducts(categoryId);
    products.value = list;
  }

  // 获取分类列表
  Future<void> _fetchCategories() async {
    var list = await repo.getCategoryList();
    categoryList.value = list;
  }
}
