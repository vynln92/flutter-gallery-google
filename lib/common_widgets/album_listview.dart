import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/create_album_button_container.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/photos_library_api/album.dart';
import 'package:google_photo_gallery/ui/album_page/trip_page.dart';

class AlbumListview extends StatelessWidget {
  const AlbumListview({Key key, this.length, this.photosLibraryApi, }) : super(key: key);

  final int length;
  final PhotosLibraryApiModel photosLibraryApi;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return CreateAlbumButton();
        }

        return _buildAlbumCard(
            context, photosLibraryApi.albums[index - 1], photosLibraryApi);
      },
    );
  }

  Widget _buildSharedIcon(Album album) {
    if (album.shareInfo != null) {
      return const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.folder_shared,
            color: Colors.black38,
          ));
    } else {
      return Container();
    }
  }
  
  Widget _buildAlbumThumbnail(Album sharedAlbum) {
    if (sharedAlbum.coverPhotoBaseUrl == null ||
        sharedAlbum.mediaItemsCount == null) {
      return Container(
        height: 160,
        width: 346,
        color: Colors.grey[200],
        padding: const EdgeInsets.all(5),
        child: SvgPicture.asset(
          'assets/ic_fieldTrippa.svg',
          color: Colors.grey[350],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: '${sharedAlbum.coverPhotoBaseUrl}=w346-h160-c',
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (BuildContext context, String url, Object error) {
        print(error);
        return const Icon(Icons.error);
      },
    );
  }



  Widget _buildAlbumCard(BuildContext context, Album sharedAlbum,
      PhotosLibraryApiModel photosLibraryApi) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 33,
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => TripPage(
              album: sharedAlbum,
              searchResponse: photosLibraryApi.searchMediaItems(sharedAlbum.id),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: _buildAlbumThumbnail(sharedAlbum),
            ),
            Container(
              height: 52,
              padding: const EdgeInsets.only(left: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                _buildSharedIcon(sharedAlbum),
                Align(
                  alignment: const FractionalOffset(0, 0.5),
                  child: Text(
                    sharedAlbum.title ?? '[no title]',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
