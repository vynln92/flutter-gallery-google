import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_photo_gallery/model/photos_library_api_model.dart';
import 'package:google_photo_gallery/ui/login/signIn_button.dart';
import 'package:google_photo_gallery/ui/album_list_page.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          // child: _buildBody()),
          child: _buildBody2()),
      backgroundColor: Colors.grey[200],
    );
  }

  void _showSignInError(BuildContext context) {
    const snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Text('Could not sign in.\n'
          'Is the Google Services file missing?'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToAlbumList(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AlbumListPage(),
      ),
    );
  }

  _buildBody2() {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (context, child, model) {
        return _buildContainer(context, model);
      },
    );
  }

  Widget _buildContainer(context, apiModel) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 80,
              ),
              Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              Text(
                'Sign in to explore your wonderful pictures',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignInButton(
                text: "Sign in with Google",
                textColor: Colors.black87,
                color: Colors.white,
                assetImageSVG: 'assets/icons/ic_google.svg',
                onPressed: () => _showSignInGoogle(context, apiModel),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'The build is under debug version, and tester must be provided in Firebase console.'
                '\nIf your email haven\'t provided, you can have a quick test with the account below:'
                '\n\nEmail: atumgameon@gmail.com'
                '\nPassword: Atumg1243',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _showSignInGoogle(context, apiModel) async {
    try {
      await apiModel.signIn() != null
          ? _navigateToAlbumList(context)
          : _showSignInError(context);
    } on Exception catch (error) {
      print(error);
      _showSignInError(context);
    }
  }

}
