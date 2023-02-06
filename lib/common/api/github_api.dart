import 'package:dio/dio.dart';

import '../models/github/github_releases_item.dart';
import 'api_constants.dart';

class GithubApi {
  static Future<GithubReleasesItemModel> requestLatestRelease() async {
    var response = await Dio().get(ApiConstants.githubLatestRelease,
        options: Options(headers: {
          "Authorization": "token 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"
        }));

    return GithubReleasesItemModel.fromJson(response.data);
  }
}
