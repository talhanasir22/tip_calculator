import 'package:flutter/material.dart';

class SecondaryButton extends StatefulWidget{
  final VoidCallback onpress;
  final IconData icon;
  const SecondaryButton({super.key, required this.onpress, required this.icon});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onpress,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF0d3b99),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(widget.icon,
            color: Colors.white,),

        ),
      ),
    );
  }
}