import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  String text;
  Function()? onTap;
  Color? bgColor;
  EdgeInsetsGeometry? padding;
  double? width;
  double? height;
  double? elevation;
  Color? txtColor;
  bool? outlineButton;
  double? fontsize;
  Widget? child;
  double borderRadius;
  BoxConstraints constraints;
  ThemeButton(
      {Key? key,
      this.onTap,
      this.constraints = const BoxConstraints(),
      this.borderRadius = 20,
      this.txtColor = Colors.black,
      this.elevation = 0,
      required this.text,
      this.bgColor = const Color(0xff5ed5a8),
      this.padding = const EdgeInsets.symmetric(vertical: 10),
      this.height = 55,
      this.fontsize = 16,
      this.outlineButton = false,
      this.child,
      this.width = double.infinity})
      : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding!,
      child: Container(
        constraints: widget.constraints,
        width: widget.width,
        height: widget.height,
        child: ElevatedButton(
            onPressed: widget.onTap ?? () {},
            style: OutlinedButton.styleFrom(
                backgroundColor:
                    widget.outlineButton! ? Colors.transparent : widget.bgColor,
                shape: RoundedRectangleBorder(
                    side: widget.outlineButton!
                        ? BorderSide(width: 1.5, color: widget.bgColor!)
                        : const BorderSide(width: 1, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(widget.borderRadius)),
                elevation: widget.elevation,
                primary: Colors.white),
            child: widget.child == null
                ? Text(widget.text,
                    style: TextStyle(
                        // letterSpacing: 1,
                        fontSize: widget.fontsize,
                        color: widget.outlineButton!
                            ? Colors.black
                            : widget.txtColor,
                        fontWeight: FontWeight.w700))
                : widget.child!),
      ),
    );
  }
}

class CustomBack extends StatefulWidget {
  Color color;
  CustomBack({super.key, required this.color});

  @override
  State<CustomBack> createState() => _CustomBackState();
}

class _CustomBackState extends State<CustomBack> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        child: Row(children: [
          Icon(
            Icons.keyboard_backspace,
            color: widget.color,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "back",
            style: TextStyle(color: widget.color, fontSize: 16),
          )
        ]),
      ),
    );
  }
}
