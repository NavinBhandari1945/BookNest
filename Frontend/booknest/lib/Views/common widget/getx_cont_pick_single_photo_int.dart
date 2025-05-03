import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickSinglePhotoGetxInt extends GetxController {
  RxString imagePath = "".obs; // To store the file name (not path in web)
  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null); // To store the image in bytes

  // Method to pick an image
  Future<int> pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Get the file name and extension
        String fileName = image.name.toLowerCase();
        String? fileExtension = fileName.split('.').last;

        print("File name: $fileName");
        print("File extension: $fileExtension");

        // Validate file extension
        if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
          // Update the image path (use file name for reference)
          imagePath.value = fileName;

          // Read the image as bytes
          imageBytes.value = await image.readAsBytes();

          print("Image selected successfully.");
          return 1;
        } else {
          print("Invalid photo format. Selected file: $fileName");
          return 2;
        }
      } else {
        print("Image not selected.");
        return 3;
      }
    } catch (e) {
      print("Exception caught while selecting image: $e");
      return 4;
    }
  }
}

