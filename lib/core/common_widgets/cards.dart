import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/common_widgets/common_theme.dart';
import 'package:ocean_builder/core/common_widgets/flutter_switch.dart';

class GenericCard extends StatefulWidget {
  const GenericCard(
      {Key key,
      this.hasSwitch,
      this.switchValue,
      this.title,
      this.dataIcon,
      this.data,
      this.subData,
      this.onControllPressed,
      this.onTap})
      : super(key: key);

  final String title;
  final String dataIcon;
  final String data;
  final String subData;
  final bool hasSwitch;
  final bool switchValue;
  final Function onControllPressed;
  final Function onTap;

  @override
  _GenericCardState createState() => _GenericCardState();
}

class _GenericCardState extends State<GenericCard> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.switchValue ?? true;
  }

  @override
  void didUpdateWidget(GenericCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isOn = widget.switchValue ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: CommonTheme.white,
        semanticContainer: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.hasSwitch ? _titleWithSwitch() : _title(),
              _divider(),
              _data(),
            ],
          ),
        ),
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: CommonTheme.primaryLight,
      height: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            '${widget.title}',
            style: CommonTheme.tsBodyDefault.apply(color: CommonTheme.primary),
          )
        ],
      ),
    );
  }

  _titleWithSwitch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.title}',
            style: CommonTheme.tsBodyDefault.apply(color: CommonTheme.primary),
          ),
          FlutterSwitch(
            // valueFontSize: 48,
            toggleColor: Colors.white,
            value: _isOn,
            // borderRadius: 24,
            height: 20,
            width: 36,
            toggleSize: 16,
            padding: 0.0,
            showOnOff: false,
            activeColor: CommonTheme.success,
            inactiveColor: CommonTheme.greyLighter,
            onToggle: (val) {
              setState(() {
                _isOn = val;
              });
            },
          ),
        ],
      ),
    );
  }

  _data() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.dataIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    widget.dataIcon,
                    fit: BoxFit.scaleDown,
                    width: 12,
                    height: 12,
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              '${widget.data ?? ''}',
              style: CommonTheme.tsBodyExtraSmall.apply(
                  color: _isOn ? CommonTheme.greyDark : CommonTheme.greyLight),
            ),
          ),
          Text(
            '${widget.subData ?? ''}',
            style: CommonTheme.tsBodyExtraSmall
                .apply(color: _isOn ? CommonTheme.grey : CommonTheme.greyLight),
          ),
        ],
      ),
    );
  }
}
