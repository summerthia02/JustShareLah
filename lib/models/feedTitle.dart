import 'package:flutter/material.dart';
import 'package:justsharelah_v1/const_templates.dart';

class FeedTitle extends StatelessWidget {
  const FeedTitle({
    Key? key,
    required this.title,
    required this.pressSeeAll,
  }) : super(key: key);
  final String title;
  final VoidCallback pressSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kBodyText.copyWith(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: pressSeeAll,
          child: const Text(
            "See All",
            style: TextStyle(color: Colors.black54),
          ),
        )
      ],
    );
  }
}
