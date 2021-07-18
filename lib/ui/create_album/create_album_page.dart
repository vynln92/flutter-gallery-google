import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/generated/l10n.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateAlbumPage extends StatefulWidget {
  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController albumNameFormController = TextEditingController();

  @override
  void dispose() {
    albumNameFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.create_album),),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Assets.imgCreateAlbum,
                    ),
                    SizedBox(height: 80,),
                    TextFormField(
                      controller: albumNameFormController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: S.current.album_name,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      child: Text(
                        S.current.this_will_create,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: CustomElevatedButton(
                        onPressed: () => _createAlbum(context),
                        child: Text(S.current.create_album),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _createAlbum(BuildContext context) async {
    // Display the loading indicator.
    setState(() => _isLoading = true);

    await ScopedModel.of<PhotosLibraryApiModel>(context)
        .createAlbum(albumNameFormController.text);

    // Hide the loading indicator.
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }
}
