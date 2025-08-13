import 'package:flutter/material.dart';

enum AlertBtnPosition { leftRignt, topDown }

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String colorBtnLabel;
  final String? dimmedBtnLabel;
  final AlertBtnPosition position;
  final void Function()? onColorBtn;
  final void Function()? onDimmedBtn;
  const CustomAlertDialog(
      {super.key,
      required this.title,
      this.onColorBtn,
      this.onDimmedBtn,
      required this.colorBtnLabel,
      this.dimmedBtnLabel,
      required this.subtitle,
      this.position = AlertBtnPosition.leftRignt});
  Future<T?> show<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => this,
    );
  }

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(widget.title),
      content: widget.position == AlertBtnPosition.topDown
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [_subtitle(), gapHeight(), ..._listButton()],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subtitle(),
                gapHeight(height: 20),
                Row(
                  children: _listButton().reversed.toList(),
                )
              ],
            ),
    );
  }

  Widget _subtitle() {
    return Text(widget.subtitle);
  }

  SizedBox gapHeight({double height = 10}) {
    return SizedBox(height: height);
  }

  List<Widget> _listButton() {
    return [
      _button(onPressed: widget.onColorBtn, title: widget.colorBtnLabel),
      if (widget.dimmedBtnLabel != null)
        _button(
            color: Colors.grey,
            onPressed: widget.onDimmedBtn,
            title: widget.dimmedBtnLabel ?? "-"),
    ];
  }

  Expanded _button(
      {required String title,
      required void Function()? onPressed,
      Color? color}) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: onPressed,
            child: Text(title)),
      ),
    ));
  }
}
