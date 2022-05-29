import 'dart:io';

import 'package:fchatty/custom_widget/custom_elevated_button.dart';
import 'package:fchatty/custom_widget/custom_alert_dialog.dart';
import 'package:fchatty/service/admob_service.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controllerUserName = TextEditingController();
  XFile? _profilePhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    // AdmobIslemleri.myBannerAd = AdmobIslemleri.buildBannerAd();
    // AdmobIslemleri.myBannerAd
    //   ..load()
    //   ..show(anchorOffset: 180);
    debugPrint(" #################### banner######################");
    loadStaticBannerAd();
  }

  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  void loadStaticBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdmobService.bannerAdUnitId, //BannerAd.testAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          setState(() {
            _bannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _getPhotoFromCamera() async {
    var _newPhoto = await _picker.pickImage(source: ImageSource.camera);

    if (_newPhoto == null) {
      return;
    }
    setState(() {
      _profilePhoto = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  void getPhotoFromGallery() async {
    var _newPhoto = await _picker.pickImage(source: ImageSource.gallery);
    if (_newPhoto == null) {
      return;
    }
    setState(() {
      _profilePhoto = _newPhoto;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.read<UserViewCubit>();
    _controllerUserName.text = userModel.user!.userName!;

    //debugPrint("Profil sayfasındaki user degerleri :" + userModel.user.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          TextButton(
            onPressed: () => _askConfirmationSignOut(context),
            child: const Text(
              "Sing out",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text("Camera"),
                                  onTap: () {
                                    _getPhotoFromCamera();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text("Gallery"),
                                  onTap: () {
                                    getPhotoFromGallery();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: // circleAvatarBGImage(),
                        (_profilePhoto != null)
                            ? FileImage(File(_profilePhoto!.path)) as ImageProvider
                            : NetworkImage(userModel.user!.profilURL!),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: userModel.user!.email,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    hintText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomElevatedButton(
                  buttonText: "Save Changes",
                  onPressed: () {
                    _updateUserName(context);
                    _updateProfilePhoto(context);
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              _buildBanner()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _singOut(BuildContext context) async {
    final userModel = context.read<UserViewCubit>();
    bool result = await userModel.signOut();
    return result;
  }

  Future _askConfirmationSignOut(BuildContext context) async {
    final result = await CustomAlertDialog(
      title: "Confirmation?",
      content: "are you sure for exit?",
      okButtonCaption: "Yes",
      cancelButtonCaption: "Cancel",
    ).showAlertDialog(context);

    if (result == true) {
      _singOut(context);
    }
  }

  void _updateUserName(BuildContext context) async {
    final userModel = context.read<UserViewCubit>();
    if (userModel.user!.userName != _controllerUserName.text) {
      var updateResult = await userModel.updateUserName(userModel.user!.userId, _controllerUserName.text);

      if (updateResult == true) {
        CustomAlertDialog(
          title: "Success",
          content: "Updated username",
          okButtonCaption: 'OK',
        ).showAlertDialog(context);
      } else {
        _controllerUserName.text = userModel.user!.userName!;
        CustomAlertDialog(
          title: "Error",
          content: "Already exists Username, Try different Username!",
          okButtonCaption: 'Ok',
        ).showAlertDialog(context);
      }
    }
  }

  void _updateProfilePhoto(BuildContext context) async {
    if (_profilePhoto != null) {
      final userModel = context.read<UserViewCubit>();
      File photofile = File(_profilePhoto!.path);
      var url = await userModel.uploadFile(userModel.user!.userId, "profil_foto", photofile);
      if (url.isNotEmpty) {
        CustomAlertDialog(
          title: "Success",
          content: "Updated photo",
          okButtonCaption: 'Ok',
        ).showAlertDialog(context);
      }
    }
  }

  Widget _buildBanner() {
    if (_bannerAdIsLoaded) {
      return Container(
        margin: const EdgeInsets.all(8),
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(
          ad: _bannerAd!,
        ),
      );
    } else {
      return Container();
    }
  }
}
