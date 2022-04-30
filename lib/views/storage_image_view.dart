import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImageView extends StatelessWidget {
  final Reference image;
  const StorageImageView({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: image.getData(),
        builder: (context, snapShot) {
          switch (snapShot.connectionState) {
            case ConnectionState.none:

            case ConnectionState.waiting:
            // TODO: Handle this case.

            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.done:
              if (snapShot.hasData) {
                final data = snapShot.data!;
                return Image.memory(
                  data,
                  fit: BoxFit.cover,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        });
  }
}
