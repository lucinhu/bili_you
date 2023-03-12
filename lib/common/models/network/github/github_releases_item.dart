// To parse this JSON data, do
//
//     final githubReleasesItemModel = githubReleasesItemModelFromJson(jsonString);

import 'dart:convert';

class GithubReleasesItemModel {
  GithubReleasesItemModel({
    this.url,
    this.assetsUrl,
    this.uploadUrl,
    this.htmlUrl,
    this.id,
    this.author,
    this.nodeId,
    this.tagName,
    this.targetCommitish,
    this.name,
    this.draft,
    this.prerelease,
    this.createdAt,
    this.publishedAt,
    this.assets,
    this.tarballUrl,
    this.zipballUrl,
    this.body,
  });

  String? url;
  String? assetsUrl;
  String? uploadUrl;
  String? htmlUrl;
  int? id;
  Author? author;
  String? nodeId;
  String? tagName;
  String? targetCommitish;
  String? name;
  bool? draft;
  bool? prerelease;
  DateTime? createdAt;
  DateTime? publishedAt;
  List<Asset?>? assets;
  String? tarballUrl;
  String? zipballUrl;
  String? body;

  factory GithubReleasesItemModel.fromRawJson(String str) =>
      GithubReleasesItemModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GithubReleasesItemModel.fromJson(Map<String, dynamic> json) =>
      GithubReleasesItemModel(
        url: json["url"],
        assetsUrl: json["assets_url"],
        uploadUrl: json["upload_url"],
        htmlUrl: json["html_url"],
        id: json["id"],
        author: Author.fromJson(json["author"]),
        nodeId: json["node_id"],
        tagName: json["tag_name"],
        targetCommitish: json["target_commitish"],
        name: json["name"],
        draft: json["draft"],
        prerelease: json["prerelease"],
        createdAt: DateTime.parse(json["created_at"]),
        publishedAt: DateTime.parse(json["published_at"]),
        assets: json["assets"] == null
            ? []
            : List<Asset?>.from(json["assets"]!.map((x) => Asset.fromJson(x))),
        tarballUrl: json["tarball_url"],
        zipballUrl: json["zipball_url"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "assets_url": assetsUrl,
        "upload_url": uploadUrl,
        "html_url": htmlUrl,
        "id": id,
        "author": author!.toJson(),
        "node_id": nodeId,
        "tag_name": tagName,
        "target_commitish": targetCommitish,
        "name": name,
        "draft": draft,
        "prerelease": prerelease,
        "created_at": createdAt?.toIso8601String(),
        "published_at": publishedAt?.toIso8601String(),
        "assets": assets == null
            ? []
            : List<dynamic>.from(assets!.map((x) => x!.toJson())),
        "tarball_url": tarballUrl,
        "zipball_url": zipballUrl,
        "body": body,
      };
}

class Asset {
  Asset({
    this.url,
    this.id,
    this.nodeId,
    this.name,
    this.label,
    this.uploader,
    this.contentType,
    this.state,
    this.size,
    this.downloadCount,
    this.createdAt,
    this.updatedAt,
    this.browserDownloadUrl,
  });

  String? url;
  int? id;
  String? nodeId;
  String? name;
  String? label;
  Author? uploader;
  String? contentType;
  String? state;
  int? size;
  int? downloadCount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? browserDownloadUrl;

  factory Asset.fromRawJson(String str) => Asset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        url: json["url"],
        id: json["id"],
        nodeId: json["node_id"],
        name: json["name"],
        label: json["label"],
        uploader: Author.fromJson(json["uploader"]),
        contentType: json["content_type"],
        state: json["state"],
        size: json["size"],
        downloadCount: json["download_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        browserDownloadUrl: json["browser_download_url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "id": id,
        "node_id": nodeId,
        "name": name,
        "label": label,
        "uploader": uploader!.toJson(),
        "content_type": contentType,
        "state": state,
        "size": size,
        "download_count": downloadCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "browser_download_url": browserDownloadUrl,
      };
}

class Author {
  Author({
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
  });

  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  bool? siteAdmin;

  factory Author.fromRawJson(String str) => Author.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        login: json["login"],
        id: json["id"],
        nodeId: json["node_id"],
        avatarUrl: json["avatar_url"],
        gravatarId: json["gravatar_id"],
        url: json["url"],
        htmlUrl: json["html_url"],
        followersUrl: json["followers_url"],
        followingUrl: json["following_url"],
        gistsUrl: json["gists_url"],
        starredUrl: json["starred_url"],
        subscriptionsUrl: json["subscriptions_url"],
        organizationsUrl: json["organizations_url"],
        reposUrl: json["repos_url"],
        eventsUrl: json["events_url"],
        receivedEventsUrl: json["received_events_url"],
        type: json["type"],
        siteAdmin: json["site_admin"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "id": id,
        "node_id": nodeId,
        "avatar_url": avatarUrl,
        "gravatar_id": gravatarId,
        "url": url,
        "html_url": htmlUrl,
        "followers_url": followersUrl,
        "following_url": followingUrl,
        "gists_url": gistsUrl,
        "starred_url": starredUrl,
        "subscriptions_url": subscriptionsUrl,
        "organizations_url": organizationsUrl,
        "repos_url": reposUrl,
        "events_url": eventsUrl,
        "received_events_url": receivedEventsUrl,
        "type": type,
        "site_admin": siteAdmin,
      };
}
