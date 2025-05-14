import 'dart:convert';
import 'package:booknest/Views/common%20widget/commonbutton.dart';
import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
import 'package:booknest/Views/common%20widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

// Widget definition section
class SendEmail extends StatefulWidget {
  final String email;
  final String usertype;
  final String jwttoken;
  final String Message;
  const SendEmail({
    super.key,
    required this.jwttoken,
    required this.usertype,
    required this.email,
    required this.Message
  });

  @override
  State<SendEmail> createState() => _SendEmailState();
}

// State management and initialization section
class _SendEmailState extends State<SendEmail> {
  final namecont = TextEditingController();
  final email = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();

  Future<int> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      const serviceId = "service_wn7e1b7";
      const userId = "55pnpAt50ARjpcT9f";
      const templateId = "template_larap3m";
      const privateKey = "kNdcuy4zAUFmCzDYG9iZ2"; // Replace with your EmailJS private key
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

      final headers = {
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "service_id": serviceId,
        "user_id": userId,
        "template_id": templateId,
        "accessToken": privateKey,
        "template_params": {
          "user_name": name,
          "user_email": email,
          "user_subject": subject,
          "user_message": message,
        },
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print("EmailJS response: ${response.body}");
      print("Status code: ${response.statusCode}");
      return response.statusCode == 200 ? 1 : 0;
    } catch (e) {
      print("Error: ${e.toString()}");
      return 0;
    }
  }

  @override
  void dispose() {
    namecont.dispose();
    email.dispose();
    subject.dispose();
    message.dispose();
    super.dispose();
  }

  // UI building section
  @override
  Widget build(BuildContext context) {
    var widthval = MediaQuery.of(context).size.width;
    var heightval = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!.withOpacity(0.9),
              Colors.white.withOpacity(0.95)
            ],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Form header
            Padding(
              padding: EdgeInsets.symmetric(vertical: heightval * 0.02),
              child: Text(
                'Send Email',
                style: TextStyle(
                  fontSize: widthval * 0.045,
                  color: Colors.green[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Form fields section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: heightval * 0.01),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextField_obs_false(
                      "Enter Name",
                      "",
                      false,
                      namecont,
                      context,
                    ),
                    SizedBox(height: heightval * 0.02),
                    CommonTextField_obs_false(
                      "Enter Email",
                      "",
                      false,
                      email,
                      context,
                    ),
                    SizedBox(height: heightval * 0.02),
                    CommonTextField_obs_false(
                      "Enter Subject",
                      "",
                      false,
                      subject,
                      context,
                    ),
                    SizedBox(height: heightval * 0.02),
                    // Wrapping Message field in a custom TextField for multi-line support
                    TextField(
                      controller: message,
                      maxLines: 4,
                      style: TextStyle(fontSize: widthval * 0.04),
                      decoration: InputDecoration(
                        labelText: "Enter Message",
                        labelStyle: TextStyle(
                          fontSize: widthval * 0.04,
                          color: Colors.green[800],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.green[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.green[800]!),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: heightval * 0.03),
            // Send button section
            Commonbutton(
              "SEND",
                  () async {
                try {
                  if (namecont.text.isEmpty ||
                      email.text.isEmpty ||
                      subject.text.isEmpty ||
                      message.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  final result = await sendEmail(
                    name: namecont.text.trim(),
                    email: email.text.trim(),
                    subject: subject.text.trim(),
                    message: message.text.trim(),
                  );

                  print("Result: $result");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result == 1
                          ? "Email sent successfully!"
                          : "Failed to send email. Please try again."),
                    ),
                  );
                } catch (obj) {
                  print(obj.toString());
                  Toastget().Toastmsg("Send email fail.Try again.");
                }
              },
              context,
              Colors.green[800]!,
            ),
            SizedBox(height: heightval * 0.03),
          ],
        ),
      ),
    );
  }
}