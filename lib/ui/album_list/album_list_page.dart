import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/album_listview.dart';
import 'package:google_photo_gallery/common_widgets/create_album_button_container.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/generated/l10n.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/ui/create_album/create_album_page.dart';
import 'package:google_photo_gallery/ui/join_album/join_album_page.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/main_app_bar.dart';

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
                Assets.icGallerySvg,
                height: 148,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  S.current.you_not_member,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              CreateAlbumButton()
            ],
          );
        }

        return AlbumListview(length: photosLibraryApi.albums.length + 1, photosLibraryApi: photosLibraryApi,);
      },
    );
  }
}
