import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'cached_image_widget_wrapper.dart';
import 'loading.dart';

class ImageGrid extends StatelessWidget {
  final List<String> images;

  ImageGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return _buildGrid();
  }

  Widget _buildGrid() {
    int imageCount = images.length;

    // Handle 1, 2, or 3 images dynamically
    if (imageCount == 1) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(images[0])),
              ],
            ),
          ),
          // Add a card with a plus icon for adding more images
        ],
      );
    } else if (imageCount == 2) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(images[0])),
                Expanded(child: _buildImageTile(images[1])),
              ],
            ),
          ),
          // Add a card with a plus icon for adding more images
        ],
      );
    } else if (imageCount == 3) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(images[0])),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: _buildImageTile(images[1])),
                      Expanded(flex: 2, child: _buildImageTile(images[2])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add a card with a plus icon for adding more images
        ],
      );
    } else {
      // Handle case with more than 3 images (e.g., just displaying 3 and showing a "+" for more)
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildImageTile(images[0])),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(flex: 2, child: _buildImageTile(images[1])),
                      Expanded(flex: 2, child: _buildImageTile(images[2])),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '+${imageCount - 3} more stores',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add a card with a plus icon for adding more images
        ],
      );
    }
  }

  List<Widget> _buildImageTiles() {
    return images.map((imageUrl) => _buildImageTile(imageUrl)).toList();
  }

  Widget _buildImageTile(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          cachedNetworkImageWrapper(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            placeholderBuilder: (context, path) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey.withOpacity(0.2)),
                child: const Loading()),
            errorWidgetBuilder: (context, path, obj) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  'assets/images/logo.png', // Fallback image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.9), // semi-transparent black
                ],
              ),
            ),
          ),
          const Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    'Tulu Ertib',
                    maxLines: 1,
                    minFontSize: 9,
                    maxFontSize: 18,
                    stepGranularity: 1,
                    style: TextStyle(
                      color: Colors.white, // For contrast
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  AutoSizeText(
                    '3 Products',
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 12,
                    stepGranularity: 0.5,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
