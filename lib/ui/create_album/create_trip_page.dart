import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_photo_gallery/common_widgets/custom_elevated_button.dart';
import 'package:google_photo_gallery/constants/assets.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateTripPage extends StatefulWidget {
  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController tripNameFormController = TextEditingController();

  @override
  void dispose() {
    tripNameFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Album'),),
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
                    SizedBox(height: 120,),
                    TextFormField(
                      controller: tripNameFormController,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        hintText: 'Album name',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 0,
                      ),
                      child: const Text(
                        'This will create a shared album in your Google Photos'
                        ' account',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: CustomElevatedButton(
                        onPressed: () => _createTrip(context),
                        child: const Text('Create Trip'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _createTrip(BuildContext context) async {
    // Display the loading indicator.
    setState(() => _isLoading = true);

    await ScopedModel.of<PhotosLibraryApiModel>(context)
        .createAlbum(tripNameFormController.text);

    // Hide the loading indicator.
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }
}
