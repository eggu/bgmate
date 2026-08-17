import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUri(BuildContext context, Uri uri) async {
  final opened = await _tryLaunch(uri);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('페이지를 열 수 없습니다.')));
  }
}

Future<bool> _tryLaunch(Uri uri) async {
  try {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
}
