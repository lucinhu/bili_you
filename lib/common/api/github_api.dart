import 'dart:convert';

import 'package:bili_you/common/utils/http_utils.dart';
import 'package:dio/dio.dart';

import '../models/network/github/github_releases_item.dart';
import 'api_constants.dart';

class GithubApi {
  static Future<GithubReleasesItemModel> requestLatestRelease() async {
    var response = await HttpUtils().get(ApiConstants.githubLatestRelease,
        options: Options(headers: {
          "Authorization": base64
              .decode(
                  "dG9rZW4gZ2hwX05ia0huNm9aRlRJN0ZyTzFPb1R4MkF3U21oTFN0OTBhN1lQVQ==")
              .toString()
        }));
    return GithubReleasesItemModel.fromJson(response.data);
  }
}
