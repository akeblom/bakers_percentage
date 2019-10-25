import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'bread_view_model.dart';
import 'gradients.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "RobotoCondensed",
        primarySwatch: Colors.blue,
      ),
      home: BakerApp(),
    );
  }
}

class BakerApp extends StatefulWidget {
  @override
  _BakerAppState createState() => _BakerAppState();
}

class _BakerAppState extends State<BakerApp> {
  var bread = BreadViewModel();
  var textStyle = TextStyle(
      fontFamily: "RobotoCondensed",
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StaggeredGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            primary: true,
            staggeredTiles: const <StaggeredTile>[
              const StaggeredTile.extent(2, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(1, 120),
              const StaggeredTile.extent(2, 120),
            ],
            children: <Widget>[
              Container(),
              ValueBox(
                label: "Mjöl(gram)",
                min: 300,
                max: 1000,
                initialValue: 500,
                onChange: (double value) {
                  setState(() {
                    bread.flour = value;
                  });
                },
                background: Gradients.blush,
              ),
              _buildGridCell(
                label: "Vätska i autolys",
                value: "${(bread.waterInAutolys).round()}",
                background: Gradients.blush,
              ),
              ValueBox(
                label: "Levain(%)",
                background: Gradients.blush,
                isPercent: true,
                initialValue: 0.2,
                min: 0.0,
                max: 0.5,
                onChange: (value) {
                  setState(() {
                    bread.levainPercentage = value;
                  });
                },
              ),
              _buildGridCell(
                  label: "Levain(gram)",
                  value: "${bread.levainWeight}",
                  background: Gradients.blush),
              ValueBox(
                background: Gradients.taitanum,
                isPercent: true,
                label: "Salt(%)",
                initialValue: 0.1,
                min: 0.0,
                max: 0.1,
                onChange: (value) {
                  setState(() {
                    bread.saltPercentage = value;
                  });
                },
              ),
              _buildGridCell(
                  label: "Salt(gram)",
                  value: "${bread.saltWeight}",
                  background: Gradients.taitanum),
              ValueBox(
                isPercent: true,
                label: "Hydrering %",
                initialValue: 0.8,
                max: 1,
                min: 0.5,
                onChange: (double value) {
                  setState(() {
                    bread.hydrationPercentage = value;
                  });
                },
                background: Gradients.tameer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCell({String label, String value, Gradient background}) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            label,
            style: textStyle,
          ),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}

typedef void OnChange(double value);

class ValueBox extends StatefulWidget {
  final String label;
  final Gradient background;
  final double max;
  final double min;
  final double initialValue;
  final OnChange onChange;
  final bool isPercent;

  const ValueBox(
      {Key key,
      this.label,
      this.background,
      this.max,
      this.min,
      this.initialValue,
      this.onChange,
      this.isPercent = false})
      : super(key: key);
  @override
  _ValueBoxState createState() => _ValueBoxState();
}

enum DragStatus { dragging, notDragging }

class _ValueBoxState extends State<ValueBox> {
  double maxWidth;
  double dragPosition;
  double value;
  double readableValue;
  int percentFactor;
  DragStatus status;
  @override
  void initState() {
    super.initState();
    dragPosition = _unlerp(widget.initialValue);
    value = widget.initialValue;
    percentFactor = widget.isPercent ? 100 : 1;
    readableValue = (value * percentFactor).roundToDouble();
  }

  double _lerp(double value) {
    assert(value >= 0.0);
    assert(value <= 1.0);
    return value * (widget.max - widget.min) + widget.min;
  }

  // Returns a number between 0.0 and 1.0, given a value between min and max.
  double _unlerp(double value) {
    assert(value <= widget.max);
    assert(value >= widget.min);
    return widget.max > widget.min
        ? (value - widget.min) / (widget.max - widget.min)
        : 0.0;
  }

  void _updateSlider(double localPos) {
    setState(() {
      dragPosition = (localPos / maxWidth);
      value = _lerp(dragPosition);
      readableValue = (value * percentFactor);
      widget.onChange(value);
    });
  }

  void _onDragStart(DragDownDetails details) {
    status = DragStatus.dragging;
    var localPos = details.localPosition.dx.clamp(0, maxWidth);
    _updateSlider(localPos);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      status = DragStatus.notDragging;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      status = DragStatus.notDragging;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    var localPos = details.localPosition.dx.clamp(0, maxWidth);
    _updateSlider(localPos);
  }

  var textStyle = TextStyle(
      fontFamily: "RobotoCondensed",
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: _onDragUpdate,
      onPanDown: _onDragStart,
      onPanEnd: _onDragEnd,
      onTapUp: _onTapUp,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        maxWidth = constraints.maxWidth;

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: widget.background,
              ),
              width: constraints.maxWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    widget.label,
                    style: textStyle,
                  ),
                  Text(readableValue.toStringAsFixed(widget.isPercent ? 1 : 0),
                      style: textStyle),
                ],
              ),
            ),
            AnimatedOpacity(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
              opacity: status == DragStatus.dragging ? 1 : 0,
              child: Transform(
                  transform: Matrix4.translationValues(
                      -maxWidth + (dragPosition * maxWidth), 0, 0),
                  child: Container(color: Colors.white24)),
            )
          ],
        );
      }),
    );
  }
}
