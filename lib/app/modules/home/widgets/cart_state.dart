import 'package:flutter/material.dart';
import 'package:get_demo/app/modules/home/widgets/cart_badge.dart';
import 'package:get/get.dart';

class CartState extends StatelessWidget {
  const CartState({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 100,
      child: Row(
        children: [
          CartBadge(),
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
}
