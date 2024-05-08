// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'dart:developer' as dev;

// class FirebaseAuthManager {
//   //Singleton
//   static final FirebaseAuthManager instance = FirebaseAuthManager._init();
//   factory FirebaseAuthManager() => instance;
//   FirebaseAuthManager._init();
//   static late final FirebaseAuth auth;
//   String _verificationId = "";
//   Future init({required FirebaseApp app}) async {
//     auth = FirebaseAuth.instanceFor(app: app);
//   }

//   Future sendOTP(BuildContext context,
//       {required String phoneNo,
//       bool showFailedSnackbar = true,
//       bool showCodesentSnackbar = true,
//       bool showTimeoutSnackbar = true,
//       required void Function() codeSent,
//       required void Function(FirebaseAuthException) verificationFailed}) async {
//     dev.log('[Send] Attempt send code');
//     try {
//       await auth.verifyPhoneNumber(
//         phoneNumber: phoneNo,
//         timeout: const Duration(minutes: 1, seconds: 20),
//         verificationCompleted: (_) {}, // ANDROID ONLY!
//         verificationFailed: (e) {
//           verificationFailed(e);
//           dev.log('[Send] ${e.toString()}');
//           if (showFailedSnackbar) {
//             if (context.mounted) {
//               _showSnackBar(context, msg: 'Failed to send');
//             }
//           }
//         },
//         codeSent: (String verificationId, int? resendToken) async {
//           dev.log('[Success] Code successfully sent');
//           codeSent();
//           _verificationId = verificationId;
//           if (showCodesentSnackbar) {
//             if (context.mounted) {
//               _showSnackBar(context, msg: 'Code has been sent');
//             }
//           }
//         },
//         codeAutoRetrievalTimeout: (e) {
//           if (showTimeoutSnackbar) {
//             if (context.mounted) {
//               _showSnackBar(context, msg: 'Sms retrieval timeout');
//             }
//           }
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       dev.log('[Firebase Exception] $e');
//       if (context.mounted) {
//         _showSnackBar(context, msg: e.toString());
//       }
//     } catch (e) {
//       dev.log('[Catch] $e');
//       if (context.mounted) {
//         _showSnackBar(context, msg: e.toString());
//       }
//     }
//   }

//   Future<bool> verifyOtp(BuildContext context,
//       {required String smsCode,
//       Function()? onSuccess,
//       Function()? onFailed}) async {
//     dev.log('[Verify] Attempt verify code');
//     bool? isVerify;
//     final credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: smsCode,
//     );

//     try {
//       // Sign the user in (or link) with the credential
//       await auth.signInWithCredential(credential);
//       onSuccess == null ? null : onSuccess();
//       isVerify = true;
//       dev.log('[Success] Successfully verify');
//     } on FirebaseAuthException catch (e) {
//       dev.log('[Verify Exception] $e');
//       if (context.mounted) {
//         if (e.toString().contains('invalid-verification-code')) {
//           _showSnackBar(context, msg: 'Invalid sms code');
//         } else if (e.toString().contains('firebase_auth/channel-error')) {
//           _showSnackBar(context,
//               msg: 'Try again later with the code we just sent!');
//         } else {
//           _showSnackBar(context, msg: (e.toString()));
//         }
//       }
//       onFailed == null ? null : onFailed();

//       isVerify = false;
//     } catch (e) {
//       dev.log('[Catch] $e');
//       if (context.mounted) {
//         _showSnackBar(context, msg: e.toString());
//       }
//       isVerify = false;
//     }
//     return isVerify;
//   }

//   static void _showSnackBar(BuildContext context, {required String msg}) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(msg),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }
// }
