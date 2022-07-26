// share credits rewards page
// only for lending / borrowing listings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';

class ShareCreditsScreen extends StatefulWidget {
  final String listingId;
  final bool isBuyer;
  const ShareCreditsScreen(
      {Key? key, required this.listingId, required this.isBuyer})
      : super(key: key);

  @override
  State<ShareCreditsScreen> createState() => ShareCreditsScreenState();
}

class ShareCreditsScreenState extends State<ShareCreditsScreen> {
  bool updatedSC = false;
  String SCChanged = "";
  int numScChanged = 0;
  String currSC = "";
  int currIntSC = 0;
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  String? currUserEmail = FirebaseAuth.instance.currentUser!.email;
  bool hasSCUpdated = false;

  // get curr users' sharecredits
  Future<int> getCurrentSC() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    Query userDoc = users.where("uid", isEqualTo: currUserId);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        setState(() {
          currSC = res.docs[0]["share_credits"];
          // print(currSC);
          currIntSC = int.parse(currSC);
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
    return currIntSC;
  }

  // only come to this page if listing is not for rent

  Future<int?> getnumScChanged() async {
    CollectionReference listings =
        FirebaseFirestore.instance.collection("listings");
    Query userDoc = listings.where("uid", isEqualTo: widget.listingId);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        setState(() {
          SCChanged = res.docs[0]["shareCredits"];
          numScChanged = int.parse(SCChanged);
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
    return numScChanged;
  }

  Future<bool?> hasUpdatedSC() async {
    CollectionReference shareCreds =
        FirebaseFirestore.instance.collection("ShareCredits");
    Query reviewDoc = shareCreds
        .where("listingId", isEqualTo: widget.listingId)
        .where("userId", isEqualTo: currUserId);
    await reviewDoc.get().then((value) => {
          if (value.docs.isEmpty)
            {
              setState(() {
                hasSCUpdated = false;
              }),
            }
          else
            {
              setState(() {
                hasSCUpdated = true;
              }),
            }
        });
  }

  Future<void> updateShareCredits() async {
    // ONLY if create for first time then

    return await FireStoreMethods().updateShareCreds(
        numScChanged, currIntSC, currUserId, widget.isBuyer, widget.listingId);
  }

  ElevatedButton buildButtonField(
      String text, Color color, double length, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: length),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, letterSpacing: 2.5, color: Colors.black),
      ),
    );
  }

  // only if minus / add sc if haven't added

  @override
  void initState() {
    super.initState();
    getnumScChanged();
    getCurrentSC();
    hasUpdatedSC();
    updatedSC;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("images/sharecredits.png"),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 15, right: 20, top: 15),
            child: widget.isBuyer == false
                ? Text(
                    "Congratulations! You have earned $numScChanged ShareCredits !",
                    style: kHeadingText.copyWith(
                        backgroundColor: Colors.greenAccent),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "You have spent $numScChanged ShareCredits !",
                    style: kHeadingText.copyWith(
                        backgroundColor: Colors.greenAccent),
                    textAlign: TextAlign.center,
                  )),
        const SizedBox(
          height: 50,
        ),
        // Text(hasSCUpdated.toString()),
        hasSCUpdated == false
            ? widget.isBuyer == false
                ? buildButtonField("Yay, Thanks!", Colors.green, 20, () async {
                    // ONLY change if haven't changed
                    if (hasSCUpdated == false) {
                      await updateShareCredits();
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(email: currUserEmail),
                        ));
                  })
                : buildButtonField(
                    "I'll EARN IT BACK, Thanks!", Colors.green, 20, () async {
                    // ONLY change if haven't changed
                    if (updatedSC == false) {
                      await updateShareCredits();
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, "/profile");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(email: currUserEmail),
                          ));
                    }
                  })
            : Container(),
        hasSCUpdated == true
            ? Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                alignment: Alignment.center,
                child: const Text(
                  "You have already updated your Share Creds! :) ",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Container(),
      ],
    ));
  }
}
