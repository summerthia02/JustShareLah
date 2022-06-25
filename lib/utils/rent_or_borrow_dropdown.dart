import 'package:flutter/material.dart';

class RentOrBorrowButton extends StatefulWidget {
  const RentOrBorrowButton({Key? key}) : super(key: key);

  @override
  State<RentOrBorrowButton> createState() => _RentOrBorrowButtonState();
}

class _RentOrBorrowButtonState extends State<RentOrBorrowButton> {
  String dropdownValue = "Borrowing";
  List<String> listingTypes = ['Borrowing', 'Renting'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ))),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward_rounded),
      elevation: 2,
      style: const TextStyle(color: Colors.grey, fontSize: 17),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: listingTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
