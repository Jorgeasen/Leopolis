import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/services/wiki_image_service.dart';

class AssetImageWithFallback extends StatefulWidget {
  const AssetImageWithFallback({
    super.key,
    required this.assetPath,
    required this.fallbackEmoji,
    this.fit = BoxFit.contain,
    this.emojiFontSize = 96,
    this.searchTerm,
  });

  final String assetPath;
  final String fallbackEmoji;
  final BoxFit fit;
  final double emojiFontSize;

  /// Término de búsqueda para Wikipedia. Si es null se extrae del assetPath.
  final String? searchTerm;

  @override
  State<AssetImageWithFallback> createState() => _AssetImageWithFallbackState();
}

class _AssetImageWithFallbackState extends State<AssetImageWithFallback> {
  bool _assetFailed = false;
  String? _networkUrl;

  String? get _effectiveTerm {
    if (widget.searchTerm != null && widget.searchTerm!.isNotEmpty) {
      return widget.searchTerm;
    }
    return _extractFromPath(widget.assetPath);
  }

  static String? _extractFromPath(String path) {
    final filename = path.split('/').last;
    if (filename.isEmpty) return null;
    var name = filename.contains('.') ? filename.split('.').first : filename;
    // Strip trailing _N (e.g. gato_raton_1 → gato_raton)
    name = name.replaceAll(RegExp(r'_\d+$'), '');
    // Take first segment before _ (e.g. gato_raton → gato)
    final first = name.split('_').first.toLowerCase().trim();
    return first.isEmpty ? null : first;
  }

  void _onAssetError() {
    if (_assetFailed) return;
    Future.microtask(() {
      if (!mounted || _assetFailed) return;
      setState(() => _assetFailed = true);
      _fetchWikiUrl();
    });
  }

  Future<void> _fetchWikiUrl() async {
    final term = _effectiveTerm;
    if (term == null) return;
    final url = await WikiImageService.instance.getImageUrl(term);
    if (mounted) setState(() => _networkUrl = url);
  }

  @override
  Widget build(BuildContext context) {
    if (!_assetFailed) {
      return Image.asset(
        widget.assetPath,
        fit: widget.fit,
        errorBuilder: (_, __, ___) {
          _onAssetError();
          return _EmojiPlaceholder(
            emoji: widget.fallbackEmoji,
            fontSize: widget.emojiFontSize,
          );
        },
      );
    }

    if (_networkUrl != null) {
      return CachedNetworkImage(
        imageUrl: _networkUrl!,
        fit: widget.fit,
        errorWidget: (_, __, ___) => _EmojiPlaceholder(
          emoji: widget.fallbackEmoji,
          fontSize: widget.emojiFontSize,
        ),
      );
    }

    return _EmojiPlaceholder(
      emoji: widget.fallbackEmoji,
      fontSize: widget.emojiFontSize,
    );
  }
}

class _EmojiPlaceholder extends StatelessWidget {
  const _EmojiPlaceholder({required this.emoji, required this.fontSize});
  final String emoji;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        emoji,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
