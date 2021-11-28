import 'dart:io';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_storage/firebase_storage.dart';

// * Servicios de Storage de Firebase
class FirebaseApi {
  // * Subida de archivos mediante un archivo

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  // * Subida de archivos mediante data de archivos
  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}
