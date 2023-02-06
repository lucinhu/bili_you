class ApiConstants {
  static const String githubLatestRelease =
      'https://api.github.com/repos/lucinhu/bili_you/releases/latest';

  static const String userAgent =
      'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36 Edg/108.0.1462.46';

  static const String bilibiliBase = "http://www.bilibili.com";

  static const String apiBase = "https://api.bilibili.com";

  static const String passportBase = "http://passport.bilibili.com";

  static const String sSearchBase = "http://s.search.bilibili.com";

  static const String appBase = "https://app.bilibili.com";

  ///#### 获取首页推荐
  ///
  ///[feed_version]:String, 若值为V4时，会有广告，所以将它设为V3比较好。
  ///
  ///[ps]:int, 请求的推荐个数
  static const String recommendItems =
      "$apiBase/x/web-interface/index/top/feed/rcmd";

  ///申请人机验证验证码
  ///?source=main_web
  static const String captcha = "$passportBase/x/passport-login/captcha";

  ///申请短信验证码
  static const String smsCode = "$passportBase/x/passport-login/web/sms/send";

  ///短信验证码登陆
  static const String smsLogin = "$passportBase/x/passport-login/web/login/sms";

  ///生成二维码
  ///直接get请求
  static const String qrcodeGenerate =
      "$passportBase/x/passport-login/web/qrcode/generate";

  ///密码登陆前，获取publicKey和hash
  static const String passwordPublicKeyHash =
      "$passportBase/x/passport-login/web/key";

  ///密码登陆
  static const String passwordLogin =
      "$passportBase/x/passport-login/web/login";

  ///获取用户信息
  static const String userInfo = '$apiBase/x/web-interface/nav';

  ///用户状态（动态数，关注数，粉丝数）
  static const String userStat = '$apiBase/x/web-interface/nav/stat';

  ///没有头像时显示的图片
  static const String noface = 'http://i0.hdslb.com/bfs/face/member/noface.jpg';

  ///视频播放
  static const String videoPlay = '$apiBase/x/player/playurl';

  ///视频信息
  static const String videoInfo = '$apiBase/x/web-interface/view';

  //视频分p信息
  static const String videoParts = '$apiBase/x/player/pagelist';

  ///相关视频
  static const String relatedVideo = '$apiBase/x/web-interface/archive/related';

  ///默认搜索词
  static const String defualtSearchWord =
      "$apiBase/x/web-interface/wbi/search/default";

  ///热搜网页版
  static const String hotWordsWeb = "$sSearchBase/main/hotword";

  ///热搜手机版(现在使用的是这个)
  static const String hotWordsMob = "$appBase/x/v2/search/trending/ranking";

  ///搜索建议
  static const String searchSuggest = "$sSearchBase/main/suggest";

  ///分类搜索
  static const String searchWithType = "$apiBase/x/web-interface/search/type";

  ///评论
  static const String reply = "$apiBase/x/v2/reply";

  ///评论的回复
  static const String replyReply = "$apiBase/x/v2/reply/reply";

  ///弹幕
  static const String danmaku = "$apiBase/x/v2/dm/web/seg.so";
}
