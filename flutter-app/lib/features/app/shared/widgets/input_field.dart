import 'package:wisp_wizz/features/app/shared/widgets/switchable_icons.dart';
import 'package:wisp_wizz/features/user/presentation/utils/exports.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Radius? leftBorder;
  final bool? readonly;
  final TextInputType? inputType;
  final IconData? prefixInitialIcon;
  final IconData? prefixFinalIcon;
  final double? iconSize;
  final bool? autoFocus;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final VoidCallback? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;
  final Function(String value)? onChanged;
  final Color? filledColor;
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
    this.iconSize,
    this.textStyle,
    this.contentPadding,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.filledColor,
    this.onChanged,
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
      style: widget.textStyle ?? theme.textTheme.bodyMedium,
      cursorColor: theme.primaryColor,
      decoration: InputDecoration(
        prefixIcon: widget.prefixFinalIcon != null
            ? IconButton(
                onPressed: () {
                  if (_currIndex == 0) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _currIndex = 1;
                    });
                  }
                },
                iconSize: widget.iconSize,
                icon: SwitchableIcon(
                  currIndex: _currIndex,
                  intitalIcon: widget.prefixInitialIcon!,
                  finalIcon: widget.prefixFinalIcon!,
                ),
              )
            : widget.prefixInitialIcon != null
                ? Icon(
                    widget.prefixInitialIcon,
                    size: widget.iconSize,
                  )
                : null,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
                vertical: Dimensions.height10, horizontal: Dimensions.width10),
        hintText: widget.hintText,
        filled: true,
        fillColor: widget.filledColor ?? theme.primaryColorLight,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
                topLeft: widget.leftBorder ?? Radius.circular(borderRadius),
                bottomLeft: widget.leftBorder ?? Radius.circular(borderRadius)),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
                topLeft: widget.leftBorder ?? Radius.circular(borderRadius),
                bottomLeft: widget.leftBorder ?? Radius.circular(borderRadius)),
            borderSide: BorderSide.none),
      ),
      onTap: () {
        setState(() {
          _currIndex = 0;
          widget.onTap != null ? widget.onTap!() : null;
        });
      },
      onSubmitted: (value) {
        setState(() {
          _currIndex = 1;
          widget.onSubmitted != null ? widget.onSubmitted!() : null;
        });
      },
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
        setState(() {
          _currIndex = 1;
          widget.onTapOutside != null ? widget.onTapOutside!() : null;
        });
      },
      onChanged: widget.onChanged,
    );
  }
}
