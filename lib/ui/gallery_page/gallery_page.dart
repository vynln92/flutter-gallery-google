import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_photo_gallery/photos_library_api/media_item.dart';

class GalleryPage extends StatefulWidget {
  final List<MediaItem> mediaItems;
  final int sendingIndex;

  const GalleryPage({Key key, this.mediaItems, this.sendingIndex})
      : super(key: key);

  @override
  _GalleryPage createState() => _GalleryPage(mediaItems, sendingIndex);
}

class _GalleryPage extends State<GalleryPage> {
  PageController _pageController;

  double _currentPageValue = 0.0;
  final List<MediaItem> mediaItems;
  final int sendingIndex;

  _GalleryPage(this.mediaItems, this.sendingIndex);

  @override
  void initState() {
    super.initState();
    _currentPageValue = sendingIndex.toDouble();
    _pageController = PageController(viewportFraction: 0.8, initialPage: sendingIndex)
      ..addListener(
        () {
          setState(() {
            _currentPageValue = _pageController.page;
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_getUrlImage(_currentPageValue.round())),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 450,
              child: PageView.builder(
                controller: _pageController,
                itemCount: mediaItems.length,
                itemBuilder: (context, index) {
                  // 0.0 ~ 1.0
                  var scale = (1 - (_currentPageValue - index).abs());

                  return Hero(
                    tag: _getUrlImage(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(_getUrlImage(index)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30 - 30 * scale,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  mediaItems[index].description ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getUrlImage(int round) => '${mediaItems[round].baseUrl}=w364';
}