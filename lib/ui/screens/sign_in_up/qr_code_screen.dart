import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_builder/constants/constants.dart';
import 'package:ocean_builder/core/providers/ocean_builder_provider.dart';
import 'package:ocean_builder/core/providers/qr_code_data_provider.dart';
import 'package:ocean_builder/ui/widgets/appbar.dart';
import 'package:ocean_builder/ui/widgets/space_widgets.dart';
import 'package:ocean_builder/ui/widgets/ui_helper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class QRcodeScreen extends StatefulWidget {
  static const String routeName = '/qrcode';
  final String inVokedFrom;

  const QRcodeScreen({Key key, this.inVokedFrom}) : super(key: key);

  @override
  _QRcodeScreenState createState() => _QRcodeScreenState();
}

class _QRcodeScreenState extends State<QRcodeScreen> {
  final BarcodeDetector barcodeDetector =
      FirebaseVision.instance.barcodeDetector();

  @override
  void dispose() {
    barcodeDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalContext.currentScreenContext = context;

    final OceanBuilderProvider oceanBuilderProvider =
        Provider.of<OceanBuilderProvider>(context);
    final QrCodeDataProvider qrCodeDataProvider =
        Provider.of<QrCodeDataProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Appbar(ScreenTitle.QRCODE),
              Spacer(),
              UIHelper.getQRCodeButton(ButtonText.WITH_CAMERA, () {
                onQRcodeScanFromCamera(
                    oceanBuilderProvider, qrCodeDataProvider);
              }),
              SpaceH32(),
              SizedBox(height: 24.0),
              UIHelper.getQRCodeButton(ButtonText.FROM_GALLERY, () {
                onQRCodeScanFromPhoto(qrCodeDataProvider);
              }),
              SpaceH64(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  onQRcodeScanFromCamera(OceanBuilderProvider oceanBuilderProvider,
      QrCodeDataProvider qrCodeDataProvider) {
    oceanBuilderProvider.scan().then((onValue) {
      if (onValue == null) {
      } else if (onValue.contains('error')) {
      } else {
        qrCodeDataProvider.qrCodeData = onValue;
        Navigator.of(context).pushReplacementNamed(widget.inVokedFrom,
            arguments: qrCodeDataProvider.qrCodeData);
      }
    });
  }

  onQRCodeScanFromPhoto(QrCodeDataProvider qrCodeDataProvider) {
    try {
      List<Barcode> _currentBarcodeLabels;

      ImagePicker().getImage(source: ImageSource.gallery).then((file) async {
        ImageProperties properties =
            await FlutterNativeImage.getImageProperties(file.path);

        File compressedFile = await FlutterNativeImage.compressImage(file.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round());

        ImageProperties propertiesOfCompressed =
            await FlutterNativeImage.getImageProperties(compressedFile.path);

        final FirebaseVisionImage visionImage =
            FirebaseVisionImage.fromFile(compressedFile);

        barcodeDetector.detectInImage(visionImage).then((data) {
          _currentBarcodeLabels = data;
          qrCodeDataProvider.qrCodeData = _currentBarcodeLabels[0].rawValue;
          Navigator.of(context).pushReplacementNamed(widget.inVokedFrom,
              arguments: qrCodeDataProvider.qrCodeData);
        }).catchError((onError) {});
      }).catchError((onError) {});
    } catch (e) {}
  }
}
