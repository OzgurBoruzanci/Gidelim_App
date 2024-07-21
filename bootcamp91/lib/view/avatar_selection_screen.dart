import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AvatarSelectionScreen extends StatelessWidget {
  final Function(String) onAvatarSelected;

  AvatarSelectionScreen({super.key, required this.onAvatarSelected});

  final List<String> avatars = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
    'assets/images/avatars/avatar7.png',
    'assets/images/avatars/avatar8.png',
    'assets/images/avatars/avatar9.png',
    'assets/images/avatars/avatar10.png',
    'assets/images/avatars/avatar11.png',
    'assets/images/avatars/avatar12.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Minimum yüksekliği korur
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Avatar Seçin',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ),
          ),
          SizedBox(
            height: 300.0, // Sabit bir yükseklik belirleyin
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onAvatarSelected(avatars[index]);
                    Navigator.pop(context); // Seçildikten sonra kapat
                    Fluttertoast.showToast(
                      msg: "Avatar başarıyla değiştirildi!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color.fromARGB(224, 76, 175, 79),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                  child: Image.asset(avatars[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
