import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/generated/l10n.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/photos_library_api/album.dart';
import 'package:google_photo_gallery/photos_library_api/media_item.dart';
import 'package:google_photo_gallery/photos_library_api/search_media_items_response.dart';
import 'package:google_photo_gallery/ui/components/contribute_photo_dialog.dart';
import 'package:google_photo_gallery/ui/gallery_page/gallery_page.dart';
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
      backgroundColor: Colors.grey[200],
      body: _buildBuilderBody(),
    );
  }

  Builder _buildBuilderBody() {
    return Builder(builder: (BuildContext context) {
      return FutureBuilder<SearchMediaItemsResponse>(
        future: searchResponse,
        builder: _buildMediaItemList,
      );
    });
  }

  Future<void> _shareAlbum(BuildContext context) async {
    setState(() => _inSharingApiCall = true);

    var snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(S.current.sharing_album),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    await ScopedModel.of<PhotosLibraryApiModel>(context).shareAlbum(album.id);
    final updatedAlbum =
        await ScopedModel.of<PhotosLibraryApiModel>(context).getAlbum(album.id);

    setState(() {
      album = updatedAlbum;
      _inSharingApiCall = false;
    });
  }

  Future<void> _showShareToken(BuildContext context) async {
    if (album.shareInfo == null) {
      await _shareAlbum(context);
      _showTokenDialog(context);
    } else {
      _showTokenDialog(context);
    }
  }

  void _showTokenDialog(BuildContext context) {
    _showShareDialog(
        context, S.current.use_this_token, album.shareInfo.shareToken);
  }

  void _showDeleteConfirmation(BuildContext context, String mediaId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete confirmation'),
            content: Row(
              children: [
                Flexible(
                  child: Text(
                    'Do you want to delete this picture?',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.current.close),
              ),
              TextButton(
                onPressed: () {
                  _deleteMedia(context, mediaId);
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
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
                  child: Text(S.current.copy),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.current.close),
              ),
            ],
          );
        });
  }

  void _contributePhoto(BuildContext context) async {
    final contributeResult = await showDialog<ContributePhotoResult>(
      context: context,
      builder: (BuildContext context) {
        return ContributePhotoDialog();
      },
    );

    await ScopedModel.of<PhotosLibraryApiModel>(context).createMediaItem(
        contributeResult.uploadToken, album.id, contributeResult.description);

    final response = ScopedModel.of<PhotosLibraryApiModel>(context)
        .searchMediaItems(album.id);
    setState(() {
      searchResponse = response;
    });
  }

  Widget _buildMediaItemList(
      BuildContext context, AsyncSnapshot<SearchMediaItemsResponse> snapshot) {
    if (snapshot.hasData) {
      return CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160.0,
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              color: Colors.white,
              onPressed: () => _showShareToken(context),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              album.title ?? S.current.no_title,
              style: TextStyle(color: Colors.white),
            ),
            background: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.modulate),
              child: Image.asset(
                Assets.imgHeaderBackground,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (snapshot.data.mediaItems != null)
          _buildImages(snapshot.data.mediaItems),
      ]);
    }

    if (snapshot.hasError) {
      print(snapshot.error);
      return Container();
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildImages(List<MediaItem> mediaItems) => SliverToBoxAdapter(
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          primary: false,
          shrinkWrap: true,
          padding: EdgeInsets.all(2),
          itemCount: mediaItems.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onLongPress: () =>
                  _showDeleteConfirmation(context, mediaItems[index].id),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => GalleryPage(
                    mediaItems: mediaItems,
                    sendingIndex: index,
                  ),
                ),
              ),
              child: Hero(
                tag: _getUrlString(mediaItems, index),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: _getUrlString(mediaItems, index),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Opacity(
                    child: Icon(Icons.image, size: 148),
                    opacity: 0.5,
                  ),
                  errorWidget:
                      (BuildContext context, String url, Object error) {
                    print(error);
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
          ),
        ),
      );

  String _getUrlString(mediaItems, index) =>
      '${mediaItems[index].baseUrl}=w364';

  Future<void> _deleteMedia(BuildContext context, String mediaId) async {
    List<String> mediaIds = List.generate(1, (index) => mediaId);
    final result = await ScopedModel.of<PhotosLibraryApiModel>(context)
        .deleteMedia(album.id, mediaIds);

    if (result) {
      final response = ScopedModel.of<PhotosLibraryApiModel>(context)
          .searchMediaItems(album.id);
      setState(() {
        searchResponse = response;
      });
    } else {
      var snackBar = SnackBar(
        duration: Duration(seconds: 3),
        content: Text(S.current.could_not_sign_in_error),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
  }
}

class ContributePhotoResult {
  ContributePhotoResult(this.uploadToken, this.description);

  String uploadToken;
  String description;
}
