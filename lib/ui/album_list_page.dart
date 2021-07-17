import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/photos_library_api/album.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/main_app_bar.dart';
import 'create_album/create_album_page.dart';
import 'join_album/join_album_page.dart';

class AlbumListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(),
      body: _buildAlbumList(),
    );
  }

  Widget _buildAlbumList() {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (BuildContext context, Widget child,
          PhotosLibraryApiModel photosLibraryApi) {
        if (!photosLibraryApi.hasAlbums) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (photosLibraryApi.albums.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.asset(
                Assets.icGallery,
                height: 148,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You're not currently a member of any albums."
                  '\nCreate a your album or join an existing one below.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildButtons(context),
            ],
          );
        }

        return ListView.builder(
          itemCount: photosLibraryApi.albums.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildButtons(context);
            }

            return _buildAlbumCard(
                context, photosLibraryApi.albums[index - 1], photosLibraryApi);
          },
        );
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
        // onTap: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => TripPage(
        //       album: sharedAlbum,
        //       searchResponse: photosLibraryApi.searchMediaItems(sharedAlbum.id),
        //     ),
        //   ),
        // ),
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

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CustomElevatedButton(
            child: Text(
              "CREATE YOUR ALBUM",
              style: TextStyle(color: Colors.black87),
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CreateAlbumPage(),
                ),
              );
            },
          ),
          SizedBox(height: 20,),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => JoinAlbumPage(),
                ),
              );
            },
            child: const Text('YOU\'RE INVITED? JOIN NOW!'),
          ),
        ],
      ),
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
}
