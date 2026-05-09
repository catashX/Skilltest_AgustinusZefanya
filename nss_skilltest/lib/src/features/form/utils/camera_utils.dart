import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

class CameraUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> takePhotoWithWatermark() async {
    try {
      final photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return null;

      Position? pos;
      try {
        var perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
          pos = await Geolocator.getCurrentPosition();
        }
      } catch (e) {
        print(e);
      }

      String txt = DateTime.now().toString();
      if (pos != null) {
        txt += '\nLat: ${pos.latitude}, Lng: ${pos.longitude}';
      }

      final bytes = await compute(_processImage, {
        'path': photo.path,
        'watermark': txt,
      });

      if (bytes == null) return null;

      final dir = await getTemporaryDirectory();
      final f = File('${dir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await f.writeAsBytes(bytes);

      return f;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Uint8List?> _processImage(Map params) async {
    try {
      final path = params['path'];
      final watermark = params['watermark'];

      final bytes = File(path).readAsBytesSync();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      if (image.width > 1200) {
        image = img.copyResize(image, width: 1200);
      }

      img.drawString(
        image,
        watermark,
        font: img.arial24,
        x: 20,
        y: 20,
        color: img.ColorRgb8(255, 0, 0),
      );

      return img.encodeJpg(image, quality: 70);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
