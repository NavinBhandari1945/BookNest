import 'dart:io';
import 'dart:typed_data'; // For byte data
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class pick_single_photo_getx extends GetxController {
  RxString imagePath = "".obs; // To store the file path
  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null); // To store the image in bytes
  // Method to pick an image
  Future<bool> pickImage() async {
    try
    {
          final ImagePicker imagePicker = ImagePicker();
          final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            // Validate file extension
            String fileExtension = image.path.split('.').last.toLowerCase();
            if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
              // Update the image path
              imagePath.value = image.path;
              // Convert the image file to bytes and store
              File imageFile = File(image.path);
              imageBytes.value = await imageFile.readAsBytes();
              print("image select success.");
              return true;
            }
            else
            {
              print("invalid photo format.");
              return false;
            }
          }
          else
          {
            print("Image not select.image picker");
            return false;
          }
    }
    catch (obj)
    {
      print("Exception caught while selecting image");
      print("Exception = ${obj.toString()}");
      return false;
    }
  }

}
