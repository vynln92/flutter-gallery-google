import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/ui/album_page/album_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContributePhotoDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContributePhotoDialogState();
}

class _ContributePhotoDialogState extends State<ContributePhotoDialog> {
  File _image;
  String _uploadToken;
  bool _isUploading = false;
  final _imagePicker = ImagePicker();

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                _buildUploadButton(context),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Add a description',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      )),
                ),
                Align(
                  alignment: const FractionalOffset(1, 0),
                  child: _buildAddButton(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildAddButton(BuildContext context) {
    if (_image == null) {
      // No image has been selected yet
      return const ElevatedButton(
        onPressed: null,
        child: Text('ADD'),
      );
    }

    if (_uploadToken == null) {
      // Upload has not completed yet
      return const ElevatedButton(
        onPressed: null,
        child: Text('Waiting for image upload'),
      );
    }

    // Otherwise, the upload has completed and an upload token is set
    return ElevatedButton(
      onPressed: () => Navigator.pop(
        context,
        ContributePhotoResult(
          _uploadToken,
          descriptionController.text,
        ),
      ),
      child: const Text('ADD'),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    if (_image != null) {
      // An image has been selected, display it in the dialog
      return Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.file(_image),
              _isUploading ? const LinearProgressIndicator() : Container(),
            ],
          ),
        ),
      );
    }

    // TODO(developer): Implement error display

    // No image has been selected yet
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextButton.icon(
        onPressed: () => _getImageGallery(context),
        // onPressed: () => _getImageCamera(context),
        label: const Text('UPLOAD PHOTO'),
        icon: const Icon(Icons.file_upload),
      ),
    );
  }

  Future _getImageCamera(BuildContext context) async {
    // Use the image_picker package to prompt the user for a photo from their
    // device.
    final pickedImage = await _imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      final pickedFile = File(pickedImage.path);
      _setStateForPickedImage(pickedFile);
    }
  }

  Future _getImageGallery(BuildContext context) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _setStateForPickedImage(imageFile);
    }
  }

  Future _setStateForPickedImage(File pickedFile) async {
    // Store the image that was selected.
    setState(() {
      _image = pickedFile;
      _isUploading = true;
    });

    // Make a request to upload the image to Google Photos once it was selected.
    final uploadToken = await ScopedModel.of<PhotosLibraryApiModel>(context)
        .uploadMediaItem(pickedFile);

    setState(() {
      // Once the upload process has completed, store the upload token.
      // This token is used together with the description to create the media
      // item later.
      _uploadToken = uploadToken;
      _isUploading = false;
    });
  }
}
