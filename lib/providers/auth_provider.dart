import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task/util/show_snack_bar.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String _verificationId = '';
  int? _resendToken;
  bool _codeSent = false;
  

  Stream<User?> get user {
    
    return _auth.authStateChanges();
  }

  get currentUser {
    
    return _auth.currentUser;
  }
   String phoneNum='';
  Future verifyPhoneNumber(String phoneNumber) async {
    phoneNum = phoneNumber;
    await _auth.verifyPhoneNumber(
     phoneNumber:  phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showPopupMessage('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        _codeSent = true;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> signWithOtp(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: otp);
    await _auth.signInWithCredential(credential);
  }

  Future<void> resendOTP() async {
    if (!_codeSent) {
      showPopupMessage('Cannot resend OTP before it is sent');
      return;
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNum,
        forceResendingToken: _resendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showPopupMessage('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _codeSent = true;
         showPopupMessage('Otp sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (error) {
     showPopupMessage(error.toString());
     print(error);
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
     
     showPopupMessage(error.toString());
    }
  }

  Future<void> updateProfile(String? name, XFile? image) async {
    try{
      showPopupMessage("Uploading");
      if (name != null) {
        await _auth.currentUser!.updateDisplayName(name);
      }
      if (image != null) {
        TaskSnapshot taskSnapshot =
            await firebaseStorage.ref('userProfiles').putFile(File(image.path));

        await _auth.currentUser!
            .updatePhotoURL(await taskSnapshot.ref.getDownloadURL());
      }
    }catch(e){
      showPopupMessage("Uploading failed");
    }
    
  }
}

final authProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});
