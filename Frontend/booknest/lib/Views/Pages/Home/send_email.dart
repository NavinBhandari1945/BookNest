// import 'dart:convert';
// import 'package:booknest/Views/common%20widget/commonbutton.dart';
// import 'package:booknest/Views/common%20widget/commontextfield_obs_false.dart';
// import 'package:booknest/Views/common%20widget/toast.dart';
// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart' as http;
//
// class SendEmail extends StatefulWidget {
//   final String email;
//   final String usertype;
//   final String jwttoken;
//   final String Message;
//   const SendEmail({
//     super.key,
//     required this.jwttoken,
//     required this.usertype,
//     required this.email,
//     required this.Message
//   });
//
//
//   @override
//   State<SendEmail> createState() => _SendEmailState();
// }
//
// class _SendEmailState extends State<SendEmail> {
//   final namecont = TextEditingController();
//   final email = TextEditingController();
//   final subject = TextEditingController();
//   final message = TextEditingController();
//
//   Future<int> sendEmail({
//     required String name,
//     required String email,
//     required String subject,
//     required String message,
//   }) async {
//     try {
//       const serviceId = "service_wn7e1b7";
//       const userId = "55pnpAt50ARjpcT9f";
//       const templateId = "template_larap3m";
//       const privateKey = "kNdcuy4zAUFmCzDYG9iZ2"; // Replace with your EmailJS private key
//       final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
//
//       final headers = {
//         'Content-Type': 'application/json',
//       };
//
//       final body = jsonEncode({
//         "service_id": serviceId,
//         "user_id": userId,
//         "template_id": templateId,
//         "accessToken": privateKey, // Include the private key
//         "template_params": {
//           "user_name": name,
//           "user_email": email,
//           "user_subject": subject,
//           "user_message": message,
//         },
//       });
//
//       final response = await http.post(
//         url,
//         headers: headers,
//         body: body,
//       );
//
//       print("EmailJS response: ${response.body}");
//       print("Status code: ${response.statusCode}");
//       return response.statusCode == 200 ? 1 : 0;
//     } catch (e) {
//       print("Error: ${e.toString()}");
//       return 0;
//     }
//   }
//
//   @override
//   void dispose() {
//     namecont.dispose();
//     email.dispose();
//     subject.dispose();
//     message.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CommonTextField_obs_false(
//               "Enter name",
//               "",
//               false,
//               namecont,
//               context,
//             ),
//             10.heightBox,
//             CommonTextField_obs_false(
//               "Enter email",
//               "",
//               false,
//               email,
//               context,
//             ),
//             10.heightBox,
//             CommonTextField_obs_false(
//               "Enter subject",
//               "",
//               false,
//               subject,
//               context,
//             ),
//             10.heightBox,
//             CommonTextField_obs_false(
//               "Enter message",
//               "",
//               false,
//               message,
//               context,
//             ),
//             20.heightBox,
//             Commonbutton(
//               "SEND",
//                   () async {
//
//                 try {
//                   // Validate inputs
//                   if (namecont.text.isEmpty ||
//                       email.text.isEmpty ||
//                       subject.text.isEmpty ||
//                       message.text.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text("Please fill in all fields")),
//                     );
//                     return;
//                   }
//
//                   // String message=
//
//                   final result = await sendEmail(
//                     name: namecont.text.trim(),
//                     email: email.text.trim(),
//                     subject: subject.text.trim(),
//                     message: message.text.trim(),
//                   );
//
//                   print("Result: $result");
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(result == 1
//                           ? "Email sent successfully!"
//                           : "Failed to send email. Please try again."),
//                     ),
//                   );
//                 }catch(obj){
//                         print(obj.toString());
//                         Toastget().Toastmsg("Send email fail.Try again.");
//                 }
//               },
//               context,
//               Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
