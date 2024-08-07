import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

String generatePresignedUrl(
  String accessKey,
  String secretKey,
  String region,
  String bucket,
  String objectKey,
  int expiresIn,
) {
  final endpoint = '$bucket.s3.$region.amazonaws.com';
  final datetime = DateTime.now().toUtc();

  final dateStamp = DateFormat('yyyyMMdd').format(datetime);
  final amzDate = DateFormat("yyyyMMdd'T'HHmmss'Z'").format(datetime);
  final credentialScope = '$dateStamp/$region/s3/aws4_request';

  final canonicalQueryString = 'X-Amz-Algorithm=AWS4-HMAC-SHA256'
      '&X-Amz-Credential=${Uri.encodeComponent('$accessKey/$credentialScope')}'
      '&X-Amz-Date=$amzDate'
      '&X-Amz-Expires=$expiresIn'
      '&X-Amz-SignedHeaders=host';

  final canonicalRequest = 'PUT\n'
      '/$objectKey\n'
      '$canonicalQueryString\n'
      'host:$endpoint\n'
      '\n'
      'host\n'
      'UNSIGNED-PAYLOAD';

  final stringToSign = 'AWS4-HMAC-SHA256\n'
      '$amzDate\n'
      '$credentialScope\n'
      '${sha256.convert(utf8.encode(canonicalRequest)).toString()}';

  final signingKey = _getSignatureKey(secretKey, dateStamp, region, 's3');
  final signature =
      Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

  final presignedUrl = 'https://$endpoint/$objectKey?$canonicalQueryString'
      '&X-Amz-Signature=$signature';

  return presignedUrl;
}

List<int> _getSignatureKey(
    String key, String dateStamp, String regionName, String serviceName) {
  final kDate = Hmac(sha256, utf8.encode('AWS4$key'))
      .convert(utf8.encode(dateStamp))
      .bytes;
  final kRegion = Hmac(sha256, kDate).convert(utf8.encode(regionName)).bytes;
  final kService =
      Hmac(sha256, kRegion).convert(utf8.encode(serviceName)).bytes;
  final kSigning =
      Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
  return kSigning;
}

//call dio to upload file to s3

Future<void> uploadFileToS3(File file, String presignedUrl) async {
  try {
    Dio dio = Dio();

    // Open the file as a stream
    var stream = file.openRead();
    var length = await file.length();

    Response response = await dio.put(
      presignedUrl,
      data: stream,
      options: Options(
        headers: {
          'Content-Type':
              'application/octet-stream', // Content-Type for binary data
          'Content-Length':
              length, // Important for setting the correct file length
        },
        sendTimeout: 60000, // 60 seconds timeout
        receiveTimeout: 60000,
      ),
    );

    if (response.statusCode == 200) {
      print('File uploaded successfully.');
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
    }
  } on DioError catch (e) {
    if (e.type == DioErrorType.sendTimeout) {
      print('Connection timed out.');
    } else if (e.type == DioErrorType.receiveTimeout) {
      print('Receive timeout.');
    } else if (e.type == DioErrorType.response) {
      print('Server error. Status code: ${e.response?.statusCode}');
    } else {
      print('Error uploading file: ${e.message}');
    }
  } catch (e) {
    print('Unexpected error: $e');
  }
}



String generateStaticS3Url(String region, String bucket, String objectKey) {
  return 'https://$bucket.s3.$region.amazonaws.com/$objectKey';
}
