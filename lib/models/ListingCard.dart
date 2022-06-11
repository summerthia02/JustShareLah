import 'package:flutter/material.dart';

import '../const_templates.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
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
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(3),
        width: 150,
        decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius))),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 162, 202, 197),
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultBorderRadius))),
              child: Image.asset(image, width: 160, height: 210),
            ),
            // ignore: prefer_const_literals_to_create_immutables
            Row(children: [
              Expanded(child: Text(title)),
              Text(
                '\$' + price.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
