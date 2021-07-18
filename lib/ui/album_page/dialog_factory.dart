import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_photo_gallery/generated/l10n.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/photos_library_api/album.dart';
import 'package:scoped_model/scoped_model.dart';

class DialogFactory {

  static void showDeleteConfirmation(BuildContext context, Album album, String mediaId, VoidCallback callback) {
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
                  callback.call();
                },
                child: Text('Okay'),
              ),
            ],
          );
        });
  }
}