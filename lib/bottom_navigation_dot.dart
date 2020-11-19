library bottom_navigation_dot;

import 'package:flutter/material.dart';

class BottomNavigationDot extends StatefulWidget {
  final List<BottomNavigationDotItem> items;
  final Color activeColor;
  final Color color;
  final Color backgroundColor;
  final double paddingBottomCircle;
  final int milliseconds;

  const BottomNavigationDot(
      {@required this.items,
      this.activeColor,
      this.color,
      this.backgroundColor,
      this.paddingBottomCircle,
      @required this.milliseconds,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomNavigationDotState();
}

class _BottomNavigationDotState extends State<BottomNavigationDot> {
  GlobalKey _key = GlobalKey();
  double _numPositionBase, _numDifferenceBase, _positionLeftIndicatorDot;
  int _indexSelected = 0;
  Color _color, _activeColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Material(
            child: Container(
          color: widget.backgroundColor,
          child: Stack(
            key: _key,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: widget.paddingBottomCircle),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        _createNavigationIconButtonList(widget.items.asMap())),
              ),
              AnimatedPositioned(
                  child:
                      CircleAvatar(radius: 2.5, backgroundColor: _activeColor),
                  duration: Duration(milliseconds: widget.milliseconds),
                  curve: Curves.easeInOut,
                  left: _positionLeftIndicatorDot,
                  bottom: 12),
            ],
          ),
        )),
      );

  List<Widget> _createNavigationIconButtonList(
      Map<int, BottomNavigationDotItem> mapItem) {
    List<Widget> children = List<Widget>();

    mapItem.forEach((index, item) => children.add(Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              if (item.showIndicator) _changeOptionBottomBar(index);
              item.onTap();
            },
            child: _NavigationIconButton(
              item.icon,
              (index == _indexSelected && item.showIndicator)
                  ? _activeColor
                  : _color,
            ),
          ),
        )));

    return children;
  }

  void _changeOptionBottomBar(int indexSelected) {
    if (indexSelected != _indexSelected) {
      setState(() {
        _positionLeftIndicatorDot =
            (_numPositionBase * (indexSelected + 1)) - _numDifferenceBase;
      });
      _indexSelected = indexSelected;
    }
  }

  _afterPage(_) {
    _color = widget.color ?? Colors.black45;
    _activeColor = widget.activeColor ?? Theme.of(context).primaryColor;
    final sizeBottomBar =
        (_key.currentContext.findRenderObject() as RenderBox).size;
    _numPositionBase = ((sizeBottomBar.width / widget.items.length));
    _numDifferenceBase = (_numPositionBase - (_numPositionBase / 2) + 2);
    setState(() {
      _positionLeftIndicatorDot = _numPositionBase - _numDifferenceBase;
    });
  }
}

class BottomNavigationDotItem {
  final IconData icon;
  final NavigationIconButtonTapCallback onTap;
  final bool showIndicator;

  const BottomNavigationDotItem(
      {@required this.icon, this.onTap, this.showIndicator = true})
      : assert(icon != null);
}

typedef NavigationIconButtonTapCallback = void Function();

class _NavigationIconButton extends StatefulWidget {
  final IconData _icon;
  final Color _colorIcon;

  const _NavigationIconButton(this._icon, this._colorIcon, {Key key})
      : super(key: key);

  @override
  _NavigationIconButtonState createState() => _NavigationIconButtonState();
}

class _NavigationIconButtonState extends State<_NavigationIconButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Icon(widget._icon, color: widget._colorIcon),
      );
}
