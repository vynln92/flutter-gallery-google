import 'package:flutter/material.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:scoped_model/scoped_model.dart';

class JoinAlbumPage extends StatefulWidget {
  @override
  _JoinAlbumPageState createState() => _JoinAlbumPageState();
}

class _JoinAlbumPageState extends State<JoinAlbumPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController shareTokenFormController =
      TextEditingController();

  @override
  void dispose() {
    shareTokenFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Album'),
      ),
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
                    SizedBox(
                      height: 80,
                    ),
                    TextFormField(
                      controller: shareTokenFormController,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'Paste the share token',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      child: const Text(
                        'This will join an album in your Google Photos account',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _joinAlbum(context),
                        child: const Text('Join Album'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _joinAlbum(BuildContext context) async {
    // Show loading indicator
    setState(() => _isLoading = true);

    // Call the API to join an album with the entered share token
    await ScopedModel.of<PhotosLibraryApiModel>(context)
        .joinSharedAlbum(shareTokenFormController.text);

    // Hide loading indicator
    setState(() => _isLoading = false);

    // Return to the previous screen
    Navigator.pop(context);
  }
}
