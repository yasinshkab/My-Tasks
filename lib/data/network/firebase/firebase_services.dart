import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_control/controller/signin_controller.dart';
import 'package:task_control/controller/signup_controller.dart';
import 'package:task_control/data/services.dart';
import 'package:task_control/data/shared%20pref/shared_pref.dart';
import 'package:task_control/screens/main%20screen/mainscreen.dart';
import 'package:task_control/model/task_model.dart';
import 'package:task_control/data/utils.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseApp app = Firebase
      .app(); // Assuming you have initialized Firebase elsewhere in your application

  static final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: app,
      databaseURL:
          'https://todo-550aa-default-rtdb.europe-west1.firebasedatabase.app');
  // static final FirebaseDatabase database = FirebaseDatabase.instance(
  //   databaseURL: 'https://rghtr-2af70-default-rtdb.europe-west1.firebasedatabase.app',
  // );
  static final signInController = Get.put(SignInController());
  static final signUpController = Get.put(SignupController());

  static Future<void> insertData(TaskModel model) async {
    String str = auth.currentUser!.email.toString();
    String node = str.substring(0, str.indexOf('@'));
    database
        .ref('Tasks')
        .child(node)
        .child(model.key!)
        .set({
          'key': model.key,
          'title': model.title,
          'description': model.description,
          'category': model.category,
          'date': model.date,
          'time': model.time,
          // 'image': model.image,
          'periority': model.periority,
          'show': model.show,
          'status': model.status
        })
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  static Future<void> createAccount() async {
    try {
      signUpController.setLoading(true);
      final String str = signUpController.email.value.text.toString();
      final String node = str.substring(0, str.indexOf('@'));
      database.ref('Accounts').child(node).set({
        'name': '${signUpController.name.value.text} ',
        'email': signUpController.email.value.text.toString(),
        'password': signUpController.password.value.text.toString(),
      }).then((value) {
        auth
            .createUserWithEmailAndPassword(
                email: signUpController.email.value.text.toString(),
                password: signUpController.password.value.text.toString())
            .then((value) {
          UserPref.setUser(
              '${signUpController.name.value.text} ',
              signUpController.email.value.text.toString(),
              signUpController.password.value.text.toString(),
              node,
              value.user!.uid.toString());
          Utils.showSnackBar(
              'Sign up',
              "Account is successfully created",
              const Icon(
                Icons.done,
                color: Colors.white,
              ));
          Get.to(HomePage());
          signUpController.setLoading(false);
        }).onError((error, stackTrace) {
          Utils.showSnackBar(
              'Error',
              Utils.extractFirebaseError(error.toString()),
              const Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
              ));
          signUpController.setLoading(false);
        });
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ));
        signUpController.setLoading(false);
      });
    } catch (e) {
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ));
      signUpController.setLoading(true);
    }
  }

  static Future<void> loginAccount() async {
    try {
      signInController.setLoading(true);
      auth
          .signInWithEmailAndPassword(
        email: signInController.email.value.text.toString(),
        password: signInController.password.value.text.toString(),
      )
          .then((value) {
        String node =
            value.user!.email!.substring(0, value.user!.email!.indexOf('@'));
        database.ref('Accounts').child(node).onValue.listen((event) {
          UserPref.setUser(
            event.snapshot.child('name').value.toString(),
            event.snapshot.child('email').value.toString(),
            event.snapshot.child('password').value.toString(),
            node,
            value.toString(),
          );
          Utils.showSnackBar(
              'Sign up',
              "Successfully Login.Welcome Back!",
              const Icon(
                Icons.done,
                color: Colors.white,
              ));
          Get.off(HomePage());
          signInController.setLoading(false);
          MyServices myServices = Get.find();

          myServices.sharedPreferences.setString("step", "2");
        }).onError((error, stackTrace) {
          Utils.showSnackBar(
              'Error',
              Utils.extractFirebaseError(error.toString()),
              const Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
              ));
          signInController.setLoading(false);
        });
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ));
        signInController.setLoading(false);
      });
    } catch (e) {
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ));
      signInController.setLoading(true);
    }
  }

  static Future<void> signInwWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn
          .signIn()
          .then((GoogleSignInAccount? googleSignInAccount) async {
        if (googleSignInAccount != null) {
          // Get the GoogleSignInAuthentication object
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          // Create an AuthCredential object
          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );

          await auth.signInWithCredential(credential).then((value) {
            final String str = value.user!.email.toString();
            final String node = str.substring(0, str.indexOf('@'));
            database.ref('Accounts').child(node).set({
              'name': value.user!.displayName,
              'email': value.user!.email,
            }).then((val) {
              // Utils.showSnackBar(
              //     'Login',
              //     'Successfully Login',
              //     const Icon(
              //       FontAwesomeIcons.triangleExclamation,
              //       color: Color.fromARGB(255, 82, 224, 30),
              //     ));
              UserPref.setUser(value.user!.displayName!, value.user!.email!,
                  "NOPASSWORD", node, value.user!.uid);
              Get.to(HomePage());
              MyServices myServices = Get.find();

              myServices.sharedPreferences.setString("step", "2");
            }).onError((error, stackTrace) {
              Utils.showSnackBar(
                  'Error',
                  Utils.extractFirebaseError(error.toString()),
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ));
              return;
            });
          }).onError((error, stackTrace) {
            Utils.showSnackBar(
                'Error',
                Utils.extractFirebaseError(error.toString()),
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ));
            return;
          });
        }
      }).onError((error, stackTrace) {
        Utils.showSnackBar(
            'Error',
            Utils.extractFirebaseError(error.toString()),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ));
        return;
      });
    } catch (e) {
      Utils.showSnackBar(
          'Error',
          Utils.extractFirebaseError(e.toString()),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ));
    }
  }

  static Future<void> signInWithApple() async {}
  static Future<int> childCount() async {
    String str = auth.currentUser!.email.toString();
    String node = str.substring(0, str.indexOf('@'));
    return database.ref('Tasks').child(node).once().then((value) {
      return value.snapshot.children.length;
    });
  }

  // static Future<void> update(
  //     String key, String updateKey, String updateValue) async {
  //   String str = auth.currentUser!.email.toString();
  //   String node = str.substring(0, str.indexOf('@'));
  //   database
  //       .ref('Tasks')
  //       .child(node)
  //       // .child(key)
  //       .update({updateKey: updateValue});
  // }

  static Future<void> updateDakta(TaskModel model) async {
    String str = auth.currentUser!.email.toString();
    String node = str.substring(0, str.indexOf('@'));
    database
        .ref('Tasks')
        .child(node)
        .child(model.key!)
        .update({
          'key': model.key,
          'title': model.title,
          'description': model.description,
          'category': model.category,
          'date': model.date,
          'time': model.time,
          // 'image': model.image,
          'periority': model.periority,
          'show': model.show,
          'status': model.status
        })
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  static Future<void> updateData(TaskModel model) async {
    try {
      String str = auth.currentUser!.email.toString();
      String node = str.substring(0, str.indexOf('@'));

      await database.ref('Tasks').child(node).child(model.key!).update({
        'key': model.key,
        'title': model.title,
        'description': model.description,
        'category': model.category,
        'date': model.date,
        'time': model.time,
        'periority': model.periority,
        'show': model.show,
        'status': model.status,
      });

      print('Task updated in Firebase');
    } catch (error) {
      print('Error updating task in Firebase: $error');
    }
  }

  static Future<void> updateUserName(String newName) async {
    try {
      String email = auth.currentUser!.email.toString();
      String node = email.substring(0, email.indexOf('@'));

      await database.ref('Accounts').child(node).update({
        'name': newName,
      });

      // Update shared preferences with new name
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('NAME', newName);

      // Optionally: update user displayName in FirebaseAuth
      User? user = auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload();
      }

      Get.snackbar('Success', 'User name updated successfully');
    } catch (error) {
      Get.snackbar('Error', 'Failed to update user name: $error');
    }
  }
}
