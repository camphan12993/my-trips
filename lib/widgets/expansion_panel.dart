import 'package:flutter/material.dart';

class AppExpansionPanel extends StatefulWidget {
  final Widget header;
  final Widget body;
  final Function()? onEdit;
  const AppExpansionPanel({
    Key? key,
    required this.header,
    required this.body,
    this.onEdit,
  }) : super(key: key);

  @override
  State<AppExpansionPanel> createState() => _AppExpansionPanelState();
}

class _AppExpansionPanelState extends State<AppExpansionPanel> {
  bool _isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpand = !_isExpand;
              });
            },
            onLongPress: widget.onEdit,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: widget.header),
                  _isExpand
                      ? Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.grey[500],
                        )
                      : Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
                ],
              ),
            ),
          ),
          if (_isExpand) widget.body
        ],
      ),
    );
  }
}
