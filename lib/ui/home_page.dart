import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login/login_page.dart';
import 'album_list/album_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (context, child, apiModel) {
        return apiModel.isLoggedIn() ? AlbumListPage() : LoginPage();
      },
    );
  }
}
