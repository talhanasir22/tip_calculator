import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tip_calculator/secondarybtn.dart';

class TextFieldSecondContainer extends StatefulWidget {
  const TextFieldSecondContainer({
    required this.text,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final String text;
  final TextEditingController controller;

  @override
  State<TextFieldSecondContainer> createState() => _TextFieldSecondContainerState();
}
class _TextFieldSecondContainerState extends State<TextFieldSecondContainer> {
  int value = 0;
  @override
  void initState() {
    super.initState();
    value = int.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = value.toString();
  }

  void updateValue(int newValue) {
    setState(() {
      value = newValue.clamp(0, 88); // Ensure value stays within the 0-999 range
      widget.controller.text = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF0d3b79),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SecondaryButton(
                  onpress: () {
                    setState(() {
                      if (value > 0) {
                        value--;
                        widget.controller.text = value.toString();
                      }
                    });
                  },
                  icon: Icons.remove
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                  onChanged: (value) {
                    // Remove leading zeros if there are more than one digit
                    if (value.startsWith('0') && value.length > 1) {
                      value = value.replaceFirst(RegExp(r'^0+'), '');
                      widget.controller.text = value;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      );
                      return; // Exit to avoid further processing
                    }

                    // Prevent updating the field if the content is '0' and '0' is pressed again
                    if (value.isEmpty || (value == '0' && widget.controller.text == '0')) {
                      return;
                    }

                    // If input length exceeds 3 digits, keep the content unchanged
                    if (value.length > 3) {
                      widget.controller.text = this.value.toString();
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      );
                      return;
                    }

                    // Try to parse the input value
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null || parsedValue < 0 || parsedValue > 80) {
                      // If parsing fails or the value is out of range, revert to the last valid value
                      widget.controller.text = this.value.toString();
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length),
                      );
                    } else {
                      // Update the value if valid
                      setState(() {
                        this.value = parsedValue;
                      });
                    }
                  },
                  onSubmitted: (value) {
                    final sanitizedValue = int.tryParse(value) ?? 0;
                    final clampedValue = sanitizedValue.clamp(0, 80);
                    updateValue(clampedValue);
                  },
                ),
              ),
              SecondaryButton(
                  onpress: () {
                    setState(() {
                      if (value < 80) {
                        value++;
                        widget.controller.text = value.toString();
                      }
                    });
                  },
                  icon: Icons.add
              ),
            ],
          ),
        ],
      ),
    );
  }
}
