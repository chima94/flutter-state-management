import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_statemanagement/bloc/app_bloc.dart';
import 'package:flutter_statemanagement/bloc/app_event.dart';
import 'package:flutter_statemanagement/bloc/app_state.dart';
import 'package:flutter_statemanagement/views/main_pop_menu.dart';
import 'package:flutter_statemanagement/views/storage_image_view.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGallery extends HookWidget {
  const PhotoGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
              onPressed: () async {
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image == null) {
                  return;
                }
                context
                    .read<AppBloc>()
                    .add(AppEventUploadImage(filePathToUpload: image.path));
              },
              icon: const Icon(Icons.upload)),
          const MainPopUpMenuButton()
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children:
            images.map((image) => StorageImageView(image: image)).toList(),
      ),
    );
  }
}
