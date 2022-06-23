import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2.3,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    image: NetworkImage(
                        "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png"))),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                shape: BoxShape.circle,
                color: Colors.cyan,
              ),
              child: Icon(Icons.edit, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
