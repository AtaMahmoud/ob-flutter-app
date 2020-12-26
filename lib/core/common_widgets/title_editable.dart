import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';

class TitleEditable extends StatefulWidget {
  TitleEditable(
      {Key? key,
      this.title,
      this.changed,
      this.controller,
      this.inputType,
      this.node,
      this.nextNode,
      this.maxLength,
      this.isEnabled})
      : super(key: key);
  final String? title;
  final Function? changed;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final FocusNode? node;
  final FocusNode? nextNode;
  final int? maxLength;
  final bool? isEnabled;

  @override
  _TitleEditableState createState() => _TitleEditableState();
}

class _TitleEditableState extends State<TitleEditable> {
  @override
  Widget build(BuildContext context) {
    // widget.controller.text = 'Title value';
    return Container(
      child: _getEditText(widget.title!, widget.changed, widget.controller!,
          widget.inputType!, widget.node!, widget.nextNode!, widget.isEnabled!,
          maxLength: widget.maxLength!),
    );
  }

  Widget _getEditText(
      String title,
      changed,
      TextEditingController controller,
      TextInputType inputType,
      FocusNode node,
      FocusNode nextNode,
      bool isEnabled,
      {int maxLength = 50}) {
    return TextField(
      enabled: isEnabled,
      autofocus: false,
      controller: controller,
      onChanged: changed,
      keyboardType: inputType,
      keyboardAppearance: Brightness.light,
      scrollPadding: EdgeInsets.only(bottom: 100),
      textInputAction:
          nextNode != null ? TextInputAction.next : TextInputAction.done,
      focusNode: node,
      onEditingComplete: () => nextNode != null
          ? FocusScope.of(context).requestFocus(nextNode)
          : FocusScope.of(context).unfocus(),
      // decoration: InputDecoration.collapsed(hintText: null),
      decoration: InputDecoration(
        hintText: '$title',
        hintStyle:
            CommonTheme.tsHeaderMobile.apply(color: CommonTheme.primaryDark),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CommonTheme.primaryLighter),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CommonTheme.primaryLighter),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        // contentPadding: EdgeInsets.all(0),
        // isDense: false,
        suffixIcon: SvgPicture.asset(
          ImagePaths.svgEdit,
          fit: BoxFit.scaleDown,
          color: CommonTheme.primaryLighter,
        ),
      ),
      style: CommonTheme.tsHeaderMobile.apply(color: CommonTheme.primaryDark),
      inputFormatters: [
        new LengthLimitingTextInputFormatter(maxLength),
      ],
    );
  }
}
