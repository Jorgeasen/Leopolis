import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class TracingCanvas extends StatefulWidget {
  const TracingCanvas({
    super.key,
    required this.letter,
    required this.canvasSize,
    required this.onSuccess,
    required this.onFailure,
  });

  final String letter;
  final Size canvasSize;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  @override
  State<TracingCanvas> createState() => TracingCanvasState();
}

class TracingCanvasState extends State<TracingCanvas> {
  final List<Offset> _points = [];

  void clear() => setState(() => _points.clear());

  Rect? _boundingBox(List<Offset> points) {
    if (points.isEmpty) return null;
    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;
    for (final p in points) {
      if (p.dx < minX) minX = p.dx;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy < minY) minY = p.dy;
      if (p.dy > maxY) maxY = p.dy;
    }
    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  // Llamado desde el padre via GlobalKey<TracingCanvasState>
  void evaluate() {
    // Mínimo de puntos para distinguir un trazo real de un toque accidental
    if (_points.length < 60) {
      widget.onFailure();
      return;
    }
    final drawn = _boundingBox(_points);
    if (drawn == null) {
      widget.onFailure();
      return;
    }
    // El trazo debe cubrir ≥30% del canvas en al menos un eje.
    // Umbral relativo al tamaño real del canvas (no fijo en px).
    final minDim = min(widget.canvasSize.width, widget.canvasSize.height);
    if (drawn.width < minDim * 0.30 && drawn.height < minDim * 0.30) {
      widget.onFailure();
      return;
    }
    // El trazo debe estar distribuido: pasar por al menos 3 zonas distintas
    // de una cuadrícula 3×3 (descarta garabatos concentrados en un área).
    if (_gridCoverage() < 3) {
      widget.onFailure();
      return;
    }
    widget.onSuccess();
  }

  // Cuenta cuántas celdas de una cuadrícula 3×3 toca el trazo
  int _gridCoverage() {
    const g = 3;
    final cells = <int>{};
    for (final p in _points) {
      final c = (p.dx / widget.canvasSize.width * g).floor().clamp(0, g - 1);
      final r = (p.dy / widget.canvasSize.height * g).floor().clamp(0, g - 1);
      cells.add(r * g + c);
    }
    return cells.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => setState(() => _points.add(d.localPosition)),
      onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
      onPanEnd: (_) => setState(() {}),
      child: Container(
        width: widget.canvasSize.width,
        height: widget.canvasSize.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.lettersColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: CustomPaint(
            painter: _TracingPainter(
              letter: widget.letter,
              points: _points,
            ),
          ),
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  const _TracingPainter({required this.letter, required this.points});

  final String letter;
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    // Letra guía en gris claro
    final tp = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.78,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE0E0E0),
          fontFamily: 'Fredoka',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: size.width);
    tp.paint(
      canvas,
      Offset(
        (size.width - tp.width) / 2,
        (size.height - tp.height) / 2,
      ),
    );

    if (points.isEmpty) return;

    // Trazo del dedo
    final paint = Paint()
      ..color = AppTheme.lettersColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TracingPainter old) => true;
}
