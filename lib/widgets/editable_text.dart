import 'package:flutter/material.dart';

class CustomEditableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Function(String) onSubmitted;
  final bool isEditing;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const CustomEditableText({
    Key? key,
    required this.text,
    required this.style,
    required this.onSubmitted,
    required this.isEditing,
    required this.onTap,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _CustomEditableTextState createState() => _CustomEditableTextState();
}

class _CustomEditableTextState extends State<CustomEditableText> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant CustomEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && !widget.isEditing) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.isEditing ? _buildTextFormField() : _buildText(),
    );
  }

  Widget _buildText() {
    return Text(
      widget.text,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTextFormField() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        autocorrect: false,
        textAlign: TextAlign.center,
        style: widget.style,
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white38,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white38,
              width: 2.0,
            ),
          ),
        ),
        onFieldSubmitted: (newText) {
          widget.onSubmitted(newText);
        },
        onTapOutside: (_) => widget.onSubmitted(_controller.text),
      ),
    );
  }
}
