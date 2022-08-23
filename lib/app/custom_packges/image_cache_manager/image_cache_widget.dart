import 'dart:io';

import 'package:flutter/material.dart';

import 'image_cache_handler.dart';

class CacheImageBuilder extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final bool showLoading;
  CacheImageBuilder({
    @required this.imageUrl,
    this.fit = BoxFit.fill,
    this.showLoading = false,
  });

  @override
  _CacheImageBuilderState createState() => _CacheImageBuilderState();
}

class _CacheImageBuilderState extends State<CacheImageBuilder> {
  var isLocalAvailable = false;
  ImageCacheHandler cacheImageBuilder = ImageCacheHandler();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: cacheImageBuilder.getAndCacheImage(widget.imageUrl),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return snapshot.hasData
            ? Image.file(
                snapshot.data,
                fit: widget.fit,
                errorBuilder:
                    (BuildContext context, Object exception, StackTrace s) {
                  return Image.network(widget.imageUrl);
                },
              )
            : widget.showLoading
                ? CircularProgressIndicator()
                : Container();
      },
    );
  }
}
