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
        title: const Text(
          '앨범 모음',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0, // Aspect ratio for each item
        ),
        padding: EdgeInsets.all(10.0),
        itemCount: galleryImages.keys.length,
        itemBuilder: (context, index) {
          String group = galleryImages.keys.elementAt(index);
          String? representativeImage = galleryImages[group]?.isNotEmpty == true ? galleryImages[group]![0] : null;
          return GestureDetector(
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
            child: Card(
              elevation: 4.0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      child: representativeImage != null
                          ? Image.file(
                        File(representativeImage),
                        fit: BoxFit.cover,
                      )
                          : const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      group,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
