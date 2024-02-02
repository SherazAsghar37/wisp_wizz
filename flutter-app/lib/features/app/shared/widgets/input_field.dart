import 'package:wisp_wizz/features/app/shared/widgets/switchable_icons.dart';
import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Radius? leftBorder;
  final bool? readonly;
  final TextInputType? inputType;
  final IconData? prefixInitialIcon;
  final IconData? prefixFinalIcon;
  final bool? autoFocus;
  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.leftBorder,
    this.readonly,
    this.inputType,
    this.prefixInitialIcon,
    this.prefixFinalIcon,
    this.autoFocus,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  int _currIndex = 1;
  ValueKey icon1 = const ValueKey('icon1');
  ValueKey icon2 = const ValueKey('icon2');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      keyboardType: widget.inputType,
      controller: widget.controller,
      showCursor: true,
      readOnly: widget.readonly ?? false,
      autofocus: widget.autoFocus ?? false,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      style: theme.textTheme.bodyMedium,
      cursorColor: theme.primaryColor,
      decoration: InputDecoration(
        prefixIcon: widget.prefixInitialIcon != null
            ? IconButton(
                onPressed: () {
                  if (_currIndex == 0) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _currIndex = 1;
                    });
                  }
                },
                icon: SwitchableIcon(
                  currIndex: _currIndex,
                  intitalIcon: widget.prefixInitialIcon!,
                  finalIcon: widget.prefixFinalIcon!,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.all(10.0),
        hintText: widget.hintText,
        filled: true,
        fillColor: theme.primaryColorLight,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10),
                topLeft:
                    widget.leftBorder ?? Radius.circular(Dimensions.height10),
                bottomLeft:
                    widget.leftBorder ?? Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.height10),
                bottomRight: Radius.circular(Dimensions.height10),
                topLeft:
                    widget.leftBorder ?? Radius.circular(Dimensions.height10),
                bottomLeft:
                    widget.leftBorder ?? Radius.circular(Dimensions.height10)),
            borderSide: BorderSide.none),
      ),
      onTap: () {
        setState(() {
          _currIndex = 0;
        });
      },
      onSubmitted: (value) {
        setState(() {
          _currIndex = 1;
        });
      },
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        setState(() {
          _currIndex = 1;
        });
      },
    );
  }
}
