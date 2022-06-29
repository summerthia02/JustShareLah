import 'package:flutter/material.dart';

import '../utils/const_templates.dart';

class BigListingCard extends StatelessWidget {
  const BigListingCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.press,
  }) : super(key: key);

  final String image, title, price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 162, 202, 197),
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadius))),
            child: Image.asset(image, width: 200, height: 210),
          ),
          // ignore: prefer_const_literals_to_create_immutables
          Container(
            padding: EdgeInsets.only(right: 40, left: 40),
            child: Row(children: [
              Expanded(child: Text(title)),
              Text(
                '\$' + price.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
