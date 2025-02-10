import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> lines = [];
  String selectedShape = "Line"; // Default shape
  String selectedEmoji = "Smiley"; // Default emoji

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
        actions: [
          // Dropdown for Shape Selection
          DropdownButton<String>(
            value: selectedShape,
            onChanged: (String? newValue) {
              setState(() {
                selectedShape = newValue!;
              });
            },
            items: ["Line", "Square", "Circle", "Arc"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(width: 20),
          // Dropdown for Emoji Selection
          DropdownButton<String>(
            value: selectedEmoji,
            onChanged: (String? newValue) {
              setState(() {
                selectedEmoji = newValue!;
              });
            },
            items: ["Smiley", "Party Face", "Heart"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            if (lines.isEmpty || lines.last.isEmpty) {
              lines.add([localPosition]);
            } else {
              lines.last.add(localPosition);
            }
          });
        },
        onPanEnd: (_) {
          setState(() {
            lines.add([]);
          });
        },
        child: CustomPaint(
          painter: MyPainter(lines, selectedShape, selectedEmoji),
          size: Size.infinite,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lines.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final String shapeType;
  final String emojiType;

  MyPainter(this.lines, this.shapeType, this.emojiType);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (final line in lines) {
      if (line.length < 2) continue;

      if (shapeType == "Line") {
        for (int i = 0; i < line.length - 1; i++) {
          canvas.drawLine(line[i], line[i + 1], paint);
        }
      } else if (shapeType == "Square") {
        final start = line.first;
        final end = line.last;
        final rect = Rect.fromPoints(start, end);
        canvas.drawRect(rect, paint);
      } else if (shapeType == "Circle") {
        final start = line.first;
        final end = line.last;
        final radius = (end - start).distance / 2;
        canvas.drawCircle(start, radius, paint);
      } else if (shapeType == "Arc") {
        final start = line.first;
        final end = line.last;
        final rect = Rect.fromPoints(start, end);
        canvas.drawArc(rect, 0, 3.14, false, paint);
      }
    }

    if (emojiType == "Smiley") {
      drawSmileyFace(canvas);
    } else if (emojiType == "Party Face") {
      drawPartyFace(canvas);
    } else if (emojiType == "Heart") {
      drawHeart(canvas);
    }
  }

  void drawSmileyFace(Canvas canvas) {
    Paint facePaint = Paint()..color = Colors.yellow;
    Paint eyePaint = Paint()..color = Colors.black;
    Paint smilePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    Offset center = Offset(200, 200);
    canvas.drawCircle(center, 50, facePaint);
    canvas.drawCircle(Offset(180, 180), 5, eyePaint);
    canvas.drawCircle(Offset(220, 180), 5, eyePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: 30), 0, 3.14, false,
        smilePaint);
  }

  void drawPartyFace(Canvas canvas) {
    drawSmileyFace(canvas);
    Paint hatPaint = Paint()..color = Colors.red;
    Paint confettiPaint = Paint()..color = Colors.green;

    Path hat = Path()
      ..moveTo(175, 160)
      ..lineTo(225, 160)
      ..lineTo(200, 120)
      ..close();
    canvas.drawPath(hat, hatPaint);

    canvas.drawCircle(Offset(190, 250), 5, confettiPaint);
    canvas.drawCircle(Offset(210, 230), 5, confettiPaint);
  }

  void drawHeart(Canvas canvas) {
    Paint heartPaint = Paint()..color = Colors.red;
    Path path = Path();
    path.moveTo(200, 200);
    path.cubicTo(150, 150, 150, 250, 200, 275);
    path.cubicTo(250, 250, 250, 150, 200, 200);
    canvas.drawPath(path, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true
  }
}
