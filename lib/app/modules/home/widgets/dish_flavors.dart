import 'package:flutter/material.dart';
import 'package:get_demo/app/data/models/dish.dart';
import 'package:get/get.dart';
import 'package:get_demo/app/modules/home/controllers/home_controller.dart';

class DishFlavors extends StatelessWidget {
  final List<DishFlavor> flavors;
  DishFlavors({required this.flavors, super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: flavors.length,
                itemBuilder: (context, index) {
                  final flavor = flavors[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flavor.name, style: const TextStyle(fontSize: 20.0)),
                      SizedBox(height: 8.0),
                      Obx(() {
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            ...List.generate(flavor.value.length, (inx) {
                              return ChoiceChip(
                                label: Text(flavor.value[inx]),
                                selected:
                                    flavor.value[inx] ==
                                    controller.selectedFlavor.value[index],
                                onSelected:
                                    (selected) => controller.selectFlavor(
                                      index,
                                      flavor.value[inx],
                                    ),
                              );
                            }),
                          ],
                        );
                      }),
                      SizedBox(height: 8.0),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
