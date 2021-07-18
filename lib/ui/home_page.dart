import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_photo_gallery/common_widgets/circular_progress.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login/login_page.dart';
import 'album_list/album_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (context, child, apiModel) {
        return FutureBuilder(
          future: apiModel.signIn(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: CircularProgress(),
                );
              default:
                return apiModel.isLoggedIn() ? AlbumListPage() : LoginPage();
            }
          },
        );
      },
    );
  }
}
