import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDropdownSheet<T> extends StatefulWidget {
  final String label;
  final T? groupValue;
  final List<T> items;
  final String Function(T data) getTitle;
  final List<T> Function(List<T> data, String? query)? onQuery;
  final void Function(T? data) onChange;
  final double initialChildSize;
  final double maxChildSize;
  final double minChildSize;

  const CustomDropdownSheet({
    required this.label,
    required this.items,
    required this.getTitle,
    super.key,
    this.groupValue,
    required this.onChange,
    this.initialChildSize = 0.7,
    this.maxChildSize = 0.7,
    this.minChildSize = 0.3,
    this.onQuery,
  });

  Future show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      isScrollControlled: true,
      builder: (_) => this,
    );
  }

  @override
  State<CustomDropdownSheet<T>> createState() => _CustomDropdownSheetState<T>();
}

class _CustomDropdownSheetState<T> extends State<CustomDropdownSheet<T>> {
  T? currValue;
  late List<T> shownItems;
  late List<T> backupItems;
  @override
  void initState() {
    super.initState();
    currValue = widget.groupValue;
    shownItems = List.of(widget.items);
    backupItems = List.of(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: widget.initialChildSize,
        minChildSize: widget.minChildSize,
        maxChildSize: widget.maxChildSize,
        builder: (context, sc) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 28, bottom: 18),
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Visibility(
                  visible: widget.onQuery != null,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                    child: MyDropdownSearchField(
                      hintText: "Search units",
                      onChanged: (val) {
                        if (widget.onQuery == null) return;
                        setState(() => shownItems = backupItems);
                        if (val.isEmpty) return;

                        final sendItems = List.of(backupItems);
                        final queryList = widget.onQuery!(sendItems, val);

                        setState(() {
                          shownItems = queryList;
                        });
                      },
                    ),
                  ),
                ),
                widget.items.isNotEmpty
                    ? Expanded(
                        child: Scrollbar(
                        thickness: 10,
                        radius: const Radius.circular(20),
                        child: ListView(
                          controller: sc,
                          children: List.generate(
                            shownItems.length,
                            (index) => RadioListTile<T>(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                groupValue: widget.groupValue,
                                value: shownItems[index],
                                title: Text(widget.getTitle(shownItems[index])),
                                onChanged: (val) {
                                  widget.onChange(val);
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ))
                    : Expanded(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.18),
                          Center(
                              child: Icon(
                            Icons.description_outlined,
                            color: Colors.grey,
                            size: MediaQuery.sizeOf(context).width * 0.15,
                          )),
                          const Center(
                              child: Text(
                            "There is no data to show",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )),
                        ],
                      ))
              ],
            ),
          );
        });
  }
}

class MyDropdownSearchField extends StatelessWidget {
  final String? title;
  final Color? fillColor;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final AutovalidateMode autovalidateMode;
  final TextStyle errorStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final int? maxLines;
  final bool? enabled;
  final bool addBorder;
  final bool isMandatory;
  const MyDropdownSearchField({
    super.key,
    this.title,
    this.fillColor,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.labelStyle,
    this.titleStyle,
    this.hintStyle,
    this.validator,
    this.onTap,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.errorStyle = const TextStyle(height: 0.01),
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.maxLines = 1,
    this.enabled = true,
    this.addBorder = true,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            children: [
              Text(title!,
                  style: titleStyle ??
                      const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500)),
              if (isMandatory)
                const Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        const SizedBox(height: 5),
        TextFormField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          initialValue: initialValue,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          validator: validator,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            hintText: hintText,
            fillColor: fillColor,
            enabledBorder: addBorder
                ? OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFA4A8AD)),
                    borderRadius: BorderRadius.circular(10),
                  )
                : null,
            contentPadding: contentPadding ??
                const EdgeInsets.only(left: 12.0, right: 12.0),
            labelStyle: labelStyle ?? const TextStyle(fontSize: 16),
            hintStyle: hintStyle ?? const TextStyle(color: Colors.grey),
            prefixIcon: prefixWidget ??
                (prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.grey)
                    : null),
            suffixIcon:
                suffixWidget ?? (suffixIcon != null ? Icon(suffixIcon) : null),
          ),
        ),
      ],
    );
  }
}
