import 'package:flutter/material.dart';

class CustomModalSheet extends StatefulWidget {
  const CustomModalSheet({super.key});

  Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      isScrollControlled: true,
      builder: (_) => this,
    );
  }

  @override
  State<CustomModalSheet> createState() => _CustomModalSheetState();
}

class _CustomModalSheetState extends State<CustomModalSheet> {
  String currValue = "Semua";
  List<String> statusFilter = [
    "Semua",
    "Belum selesai",
    "Tidak berjaya muatnaik",
    "Berjaya muatnaik"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, top: 28, bottom: 18),
          child: Text(
            'Status kompaun',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ...List.generate(
          statusFilter.length,
          (index) => RadioListTile<String>(
              controlAffinity: ListTileControlAffinity.trailing,
              groupValue: currValue,
              value: statusFilter[index],
              title: Text(statusFilter[index]),
              onChanged: (val) {
                setState(() {
                  currValue = val!;
                  Navigator.pop(context);
                });
              }),
        )
      ],
    );
  }
}
