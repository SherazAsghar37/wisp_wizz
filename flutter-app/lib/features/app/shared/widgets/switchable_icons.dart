import 'package:wisp_wizz/features/auth/presentation/utils/exports.dart';

// ignore: must_be_immutable
class SwitchableIcon extends StatelessWidget {
  SwitchableIcon({
    super.key,
    required this.intitalIcon,
    required this.finalIcon,
    required int currIndex,
    this.angle,
  }) : _currIndex = currIndex;

  final IconData intitalIcon;
  final IconData finalIcon;
  final double? angle;
  final int _currIndex;

  ValueKey icon1 = const ValueKey('icon1');
  ValueKey icon2 = const ValueKey('icon2');
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
              turns: child.key == icon1
                  ? Tween<double>(begin: 1, end: 1).animate(anim)
                  : Tween<double>(begin: 1, end: 1).animate(anim),
              child: ScaleTransition(scale: anim, child: child),
            ),
        child: _currIndex == 0
            ? Icon(finalIcon, key: icon1)
            : angle != null
                ? Transform.rotate(
                    key: icon2,
                    angle: angle!,
                    child: Icon(
                      intitalIcon,
                    ),
                  )
                : Icon(
                    intitalIcon,
                    key: icon2,
                  ));
  }
}
