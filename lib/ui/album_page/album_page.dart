import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/photos_library_api/album.dart';
import 'package:google_photo_gallery/photos_library_api/media_item.dart';
import 'package:google_photo_gallery/photos_library_api/search_media_items_response.dart';
import 'package:google_photo_gallery/ui/components/contribute_photo_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key key, this.searchResponse, this.album}) : super(key: key);

  final Future<SearchMediaItemsResponse> searchResponse;

  final Album album;

  @override
  State<StatefulWidget> createState() =>
      _AlbumPageState(searchResponse: searchResponse, album: album);
}

class _AlbumPageState extends State<AlbumPage> {
  _AlbumPageState({this.searchResponse, this.album});

  Album album;
  Future<SearchMediaItemsResponse> searchResponse;
  bool _inSharingApiCall = false;


  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _contributePhoto(context),
        child: Icon(
          Icons.file_upload,
        ),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(album.title ?? '[no title]'),
      //   elevation: 4,
      // ),
      body: _buildBuilderBody(),
    );
  }

  Builder _buildBuilderBody() {
    return Builder(builder: (BuildContext context) {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('SliverAppBar'),
              background: FlutterLogo(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('Scroll to see the SliverAppBar in effect.'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
        // child: Column(
        //   children: <Widget>[
        //     _buildShareButtons(context),
        //     FutureBuilder<SearchMediaItemsResponse>(
        //       future: searchResponse,
        //       builder: _buildMediaItemList,
        //     )
        //   ],
        // ),
      );
    });
  }

  Future<void> _shareAlbum(BuildContext context) async {
    // Show the loading indicator
    setState(() => _inSharingApiCall = true);

    const snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Sharing Album...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Share the album and update the local model
    await ScopedModel.of<PhotosLibraryApiModel>(context).shareAlbum(album.id);
    final updatedAlbum =
        await ScopedModel.of<PhotosLibraryApiModel>(context).getAlbum(album.id);

    print('Album has been shared.');
    setState(() {
      album = updatedAlbum;
      // Hide the loading indicator
      _inSharingApiCall = false;
    });
  }

  Future<void> _showShareableUrl(BuildContext context) async {
    if (album.shareInfo == null || album.shareInfo.shareableUrl == null) {
      print('Not shared, sharing album first.');

      // Album is not shared yet, share it first, then display dialog
      await _shareAlbum(context);
      _showUrlDialog(context);
    } else {
      // Album is already shared, display dialog with URL
      _showUrlDialog(context);
    }
  }

  Future<void> _showShareToken(BuildContext context) async {
    if (album.shareInfo == null) {
      print('Not shared, sharing album first.');

      // Album is not shared yet, share it first, then display dialog
      await _shareAlbum(context);
      _showTokenDialog(context);
    } else {
      // Album is already shared, display dialog with token
      _showTokenDialog(context);
    }
  }

  void _showTokenDialog(BuildContext context) {
    print('This is the shareToken:\n${album.shareInfo.shareToken}');

    _showShareDialog(
        context, 'Use this token to share', album.shareInfo.shareToken);
  }

  void _showUrlDialog(BuildContext context) {
    print('This is the shareableUrl:\n${album.shareInfo.shareableUrl}');

    _showShareDialog(
        context,
        'Share this URL with anyone. '
        'Anyone with this URL can access all items.',
        album.shareInfo.shareableUrl);
  }

  void _showShareDialog(BuildContext context, String title, String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Row(
              children: [
                Flexible(
                  child: Text(
                    text,
                  ),
                ),
                TextButton(
                  onPressed: () => Clipboard.setData(ClipboardData(text: text)),
                  child: const Text('Copy'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  void _contributePhoto(BuildContext context) async {
    // Show the contribute  dialog and upload a photo.
    final contributeResult = await showDialog<ContributePhotoResult>(
      context: context,
      builder: (BuildContext context) {
        return ContributePhotoDialog();
      },
    );

    // Create the media item from the uploaded photo.
    await ScopedModel.of<PhotosLibraryApiModel>(context).createMediaItem(
        contributeResult.uploadToken, album.id, contributeResult.description);

    // Do a new search for items inside this album and store its Future for display.
    final response = ScopedModel.of<PhotosLibraryApiModel>(context)
        .searchMediaItems(album.id);
    setState(() {
      searchResponse = response;
    });
  }

  Widget _buildShareButtons(BuildContext context) {
    if (_inSharingApiCall) {
      return const CircularProgressIndicator();
    }

    return Column(children: <Widget>[
      Container(
        width: 254,
        child: TextButton(
          onPressed: () => _showShareableUrl(context),
          child: const Text('SHARE WITH ANYONE'),
        ),
      ),
      Container(
        width: 254,
        child: TextButton(
          onPressed: () => _showShareToken(context),
          child: const Text('SHARE IN FIELD TRIPPA'),
        ),
      ),
    ]);
  }

  Widget _buildMediaItemList(
      BuildContext context, AsyncSnapshot<SearchMediaItemsResponse> snapshot) {
    if (snapshot.hasData) {
      if (snapshot.data.mediaItems == null) {
        return Container();
      }

      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data.mediaItems.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildMediaItem(snapshot.data.mediaItems[index]);
          },
        ),
      );
    }

    if (snapshot.hasError) {
      print(snapshot.error);
      return Container();
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMediaItem(MediaItem mediaItem) {
    return Column(
      children: <Widget>[
        Center(
          child: CachedNetworkImage(
            imageUrl: '${mediaItem.baseUrl}=w364',
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (BuildContext context, String url, Object error) {
              print(error);
              return const Icon(Icons.error);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 2),
          width: 364,
          child: Text(
            mediaItem.description ?? '',
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class ContributePhotoResult {
  ContributePhotoResult(this.uploadToken, this.description);

  String uploadToken;
  String description;
}
