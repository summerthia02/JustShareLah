import 'package:flutter/material.dart';

import '../utils/const_templates.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.press,
    required this.dateListed,
  }) : super(key: key);

  final String image, title, price;
  final VoidCallback press;
  final dynamic dateListed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: const EdgeInsets.all(3),
        width: 160,
        decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(defaultBorderRadius))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 162, 202, 197),
                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultBorderRadius))),
              child: Image.network(
                image,
                scale: 1.5,
              ),
            ),

            // ignore: prefer_const_literals_to_create_immutables
            Row(children: [
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
              )),
              Text(
                '\$' + price.toString(),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ]),
            Text(
              "Listed " + dateListed.toString(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
