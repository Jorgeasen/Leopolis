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

  void _evaluate() {
    // Necesita al menos 30 puntos para descartar clicks accidentales
    if (_points.length < 30) {
      widget.onFailure();
      return;
    }
    final drawn = _boundingBox(_points);
    if (drawn == null) {
      widget.onFailure();
      return;
    }
    // El trazo debe cubrir al menos 80px en alguno de los dos ejes.
    // No se exige ambos: la 'I' es vertical y válida; la 'Z' es horizontal y válida.
    if (drawn.width < 80 && drawn.height < 80) {
      widget.onFailure();
      return;
    }
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onPanStart: (d) => setState(() => _points.add(d.localPosition)),
          onPanUpdate: (d) => setState(() => _points.add(d.localPosition)),
          onPanEnd: (_) => setState(() {}), // solo repinta, no evalúa
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
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 64,
                child: ElevatedButton.icon(
                  onPressed: _evaluate,
                  icon: const Icon(Icons.check_circle_rounded, size: 26),
                  label: const Text(
                    '¡Listo!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 64,
              child: TextButton.icon(
                onPressed: clear,
                icon: const Icon(Icons.refresh_rounded, size: 26),
                label: const Text(
                  'Borrar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lettersColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ],
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
