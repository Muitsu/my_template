import 'package:flutter/material.dart';

class CustomLoadingDialog extends StatefulWidget {
  final LoadingDialogController controller;
  final bool isDissmissable;
  final String? succesMsg;
  final String? failedMsg;
  final String? errorMsg;
  final void Function(DialogState state) onFinish;

  const CustomLoadingDialog({
    super.key,
    required this.controller,
    this.isDissmissable = true,
    required this.onFinish,
    this.succesMsg,
    this.failedMsg,
    this.errorMsg,
  });

  static Future<void> show(BuildContext context,
      {required LoadingDialogController controller,
      bool isDissmissable = true,
      String? succesMsg,
      String? failedMsg,
      String? errorMsg,
      required void Function(DialogState state) onFinish}) async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => CustomLoadingDialog(
        controller: controller,
        isDissmissable: isDissmissable,
        onFinish: onFinish,
        succesMsg: succesMsg,
        failedMsg: failedMsg,
        errorMsg: errorMsg,
      ),
    );
  }

  @override
  State<CustomLoadingDialog> createState() => _CustomLoadingDialogState();
}

class _CustomLoadingDialogState extends State<CustomLoadingDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller.stateNotifier.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.stateNotifier.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (!widget.controller.state.isLoading) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onFinish(widget.controller.state);
      });
    }
    setState(() {});
  }

  String setMessage(DialogState state) {
    if (state == DialogState.success) {
      return widget.succesMsg ?? state.title;
    } else if (state == DialogState.failed) {
      return widget.failedMsg ?? state.title;
    } else if (state == DialogState.error) {
      return widget.errorMsg ?? state.title;
    } else {
      return "Loading ...";
    }
  }

  @override
  Widget build(BuildContext context) {
    DialogState state = widget.controller.stateNotifier.value;

    return PopScope(
      canPop: widget.isDissmissable,
      child: GestureDetector(
        onTap: () {
          if (widget.isDissmissable) {
            Navigator.pop(context);
          }
        },
        child: Material(
          color: Colors.black.withValues(alpha: 0.6),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: state.getHeight,
                width: state.getWidth,
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: state.widget,
                    ),
                    Visibility(
                      visible: !state.isLoading,
                      child: Text(
                        setMessage(widget.controller.state),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*=================State=================*/
enum DialogState {
  loading(
      title: "Loading ...",
      widget: CircularProgressIndicator(
        color: Colors.blue,
      )),
  success(
      title: "Success!",
      widget: Icon(
        Icons.check_circle_outline,
        size: 50,
        color: Colors.green,
      )),
  failed(
      title: "Failed, Please try again.",
      widget: Icon(
        Icons.cancel_outlined,
        size: 50,
        color: Colors.red,
      )),
  error(
      title: "Something went wrong.",
      widget: Icon(
        Icons.error_outline_rounded,
        size: 50,
        color: Colors.amber,
      ));

  double get getWidth => this == DialogState.loading ? 100 : 200;
  double get getHeight => this == DialogState.loading ? 100 : 100;
  bool get isLoading => this == DialogState.loading;

  final String title;
  final Widget widget;
  const DialogState({required this.widget, required this.title});
}

/*=================Controller=================*/
class LoadingDialogController {
  final ValueNotifier<DialogState> _stateNotifier;
  final DialogState initState;
  //NOTE: This is Initialize list method (not all programming have this)
  //To ensure the variable is initialize before body.
  //Difference than initialize inside body constructor.
  LoadingDialogController()
      : _stateNotifier = ValueNotifier(DialogState.loading),
        initState = DialogState.loading;

  ValueNotifier<DialogState> get stateNotifier => _stateNotifier;
  DialogState get state => _stateNotifier.value;
  DialogState get getInitialState => initState;

  void updateState(DialogState newState) {
    _stateNotifier.value = newState;
  }

  void dispose() {
    _stateNotifier.dispose();
  }
}
