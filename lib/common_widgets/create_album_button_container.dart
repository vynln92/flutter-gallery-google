import 'package:flutter/material.dart';
import 'package:google_photo_gallery/ui/create_album/create_album_page.dart';
import 'package:google_photo_gallery/ui/join_album/join_album_page.dart';

import 'custom_elevated_button.dart';

class CreateAlbumButton extends StatelessWidget {
  const CreateAlbumButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
