import 'package:flutter/material.dart';
import 'gallery_page.dart';
import 'dart:io';

class AlbumCollectionPage extends StatelessWidget {
  final Map<String, List<String>> galleryImages;
  final Function(String, List<String>) onImagesChanged;

  const AlbumCollectionPage({
    required this.galleryImages,
    required this.onImagesChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앨범 모음'),
      ),
      body: ListView.builder(
        itemCount: galleryImages.keys.length,
        itemBuilder: (context, index) {
          String group = galleryImages.keys.elementAt(index);
          String? representativeImage = galleryImages[group]?.isNotEmpty == true ? galleryImages[group]![0] : null;
          return ListTile(
            leading: representativeImage != null
                ? Image.file(File(representativeImage), width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image, size: 50),
            title: Text(group),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GalleryPage(
                    group: group,
                    images: galleryImages[group]!,
                    onImagesChanged: onImagesChanged,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
