class ApiConstants {
  static const String githubLatestRelease =
      'https://api.github.com/repos/lucinhu/bili_you/releases/latest';

  static const String userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15';

  static const String bilibiliBase = "https://www.bilibili.com";

  static const String apiBase = "https://api.bilibili.com";

  static const String apiLiveBase = "https://api.live.bilibili.com";

  static const String passportBase = "https://passport.bilibili.com";

  static const String sSearchBase = "https://s.search.bilibili.com";

  static const String appBase = "https://app.bilibili.com";

  ///#### 获取首页推荐
  ///
  ///get请求
  ///
  ///[feed_version]:String 若值为V4时，会有广告，所以将它设为V3比较好。
  ///
  ///[ps]:int 请求的推荐个数
  ///
  ///[refresh_idx]:int 刷新的次数
  ///
  ///需要cookie才能根据喜好推荐
  ///
  ///test: https://api.bilibili.com/x/web-interface/index/top/feed/rcmd?feed_version=V3&ps=12&fresh_idx=1
  static const String recommendItems =
      "$apiBase/x/web-interface/wbi/index/top/feed/rcmd";

  ///申请人机验证验证码
  ///?source=main_web
  ///test: http://passport.bilibili.com/x/passport-login/captcha
  static const String captcha = "$passportBase/x/passport-login/captcha";

  ///申请短信验证码
  ///post请求
  ///test: http://passtport.bilibili.com/x/passport-login/web/sms/send
  static const String smsCode = "$passportBase/x/passport-login/web/sms/send";

  ///短信验证码登录
  ///post请求
  static const String smsLogin = "$passportBase/x/passport-login/web/login/sms";

  ///生成二维码
  ///直接get请求
  static const String qrcodeGenerate =
      "$passportBase/x/passport-login/web/qrcode/generate";

  ///扫码登录
  static const String qrcodeLogin =
      "$passportBase/x/passport-login/web/qrcode/poll";

  ///密码登录前，获取publicKey和hash
  static const String passwordPublicKeyHash =
      "$passportBase/x/passport-login/web/key";

  ///密码登录
  static const String passwordLogin =
      "$passportBase/x/passport-login/web/login";

  ///获取用户信息
  static const String userInfo = '$apiBase/x/web-interface/nav';

  ///用户状态（动态数，关注数，粉丝数）
  static const String userStat = '$apiBase/x/web-interface/nav/stat';

  ///没有头像时显示的图片
  static const String noface = 'http://i0.hdslb.com/bfs/face/member/noface.jpg';

  ///视频播放
  ///test: https://api.bilibili.com/x/player/playurl?cid=1053323351&bvid=BV14L411k7zn&fnval=16
  ///test: https://api.bilibili.com/x/player/playurl?cid=993730189&avid=351273106&fnval=16&fourk=1
  static const String videoPlay = '$apiBase/x/player/playurl';

  ///视频信息
  ///test: https://api.bilibili.com/x/web-interface/view?aid=170001
  static const String videoInfo = '$apiBase/x/web-interface/view';

  ///视频分p信息
  ///test: https://api.bilibili.com/x/player/pagelist?aid=170001
  static const String videoParts = '$apiBase/x/player/pagelist';

  ///相关视频
  ///
  ///bvid, aid 任选其一
  ///
  ///[bvid]:String (不可以是aid转字符串，即不允许bvid=170001这种做法)
  ///
  ///[aid]:int
  ///
  ///test: https://api.bilibili.com/x/web-interface/archive/related?aid=170001
  static const String relatedVideo = '$apiBase/x/web-interface/archive/related';

  ///默认搜索词
  ///test: http://api.bilibili.com/x/web-interface/wbi/search/default
  static const String defualtSearchWord =
      "$apiBase/x/web-interface/wbi/search/default";

  ///热搜手机版(现在使用的是这个)
  ///test: http://app.bilibili.com/x/v2/search/trending/ranking
  static const String hotWordsMob = "$appBase/x/v2/search/trending/ranking";

  ///搜索建议
  ///test: http://s.search.bilibili.com/main/suggest
  static const String searchSuggest = "$sSearchBase/main/suggest";

  ///分类搜索
  ///test video: https://api.bilibili.com/x/web-interface/search/type?keyword=你好&search_type=video&page=5&page_size=45
  ///test bangumi: https://api.bilibili.com/x/web-interface/search/type?keyword=三国&search_type=media_bangumi&page=1&page_size=45
  static const String searchWithType = "$apiBase/x/web-interface/search/type";

  ///评论
  static const String reply = "$apiBase/x/v2/reply";

  ///评论的回复
  static const String replyReply = "$apiBase/x/v2/reply/reply";

  ///发表评论
  static const String addReply = "$apiBase/x/v2/reply/add";

  ///弹幕
  static const String danmaku = "$apiBase/x/v2/dm/web/seg.so";

  ///番剧/剧集
  static const String bangumiInfo = "$apiBase/pgc/view/web/season";

  ///用户投稿视频&查询
  static const String userVideoSearch = "$apiBase/x/space/wbi/arc/search";

  ///动态页面
  ///test: https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all?type=all&page=1&features=itemOpusStyle
  static const String dynamicFeed =
      "$apiBase/x/polymer/web-dynamic/v1/feed/all";

  ///动态页Up主面板
  static const String dynamicAuthorList = "$apiBase/x/polymer/web-dynamic/v1/portal";

  ///点赞
  static const String like = "$apiBase/x/web-interface/archive/like";

  ///判断视频是否已经点赞
  static const String hasLike = "$apiBase/x/web-interface/archive/has/like";

  ///投币
  static const String addCoin = "$apiBase/x/web-interface/coin/add";

  ///判断是否被投币
  static const String hasAddCoin = "$apiBase/x/web-interface/archive/coins";

  ///收藏
  static const String addFavourite = "$apiBase/x/v3/fav/resource/deal";

  ///判断是否已收藏
  static const String hasFavourite = "$apiBase/x/v2/fav/video/favoured";

  ///分享视频
  static const String share = "$apiBase/x/web-interface/share/add";

  ///评论点赞
  static const String replyAddLike = "$apiBase/x/v2/reply/action";

  ///上报历史记录
  static const String heartBeat = "$apiBase/x/click-interface/web/heartbeat";

  ///浏览/播放历史记录
  ///test: https://api.bilibili.com/x/web-interface/history/cursor
  static const String viewHistory = "$apiBase/x/web-interface/history/cursor";

  ///上报历史记录
  ///test: https://api.bilibili.com/x/v2/history/report
  static const String reportHistory = "$apiBase/x/v2/history/report";

  ///热门视频
  ///test: https://api.bilibili.com/x/web-interface/popular?ps=20&pn=1
  static const String popularVideos = "$apiBase/x/web-interface/popular";

  ///用户推荐直播
  ///test: https://api.live.bilibili.com/xlive/web-interface/v1/second/getUserRecommend?page=1&page_size=30&platform=web
  static const String userRecommendLive =
      "$apiLiveBase/xlive/web-interface/v1/second/getUserRecommend";

  ///直播播放链接
  ///
  ///[cid] 其实是room_id
  ///
  ///[qn] 80:流畅，150:高清，400:蓝光，10000:原画，20000:4K, 30000:杜比
  ///
  ///test: https://api.live.bilibili.com/xlive/web-room/v2/index/getRoomPlayInfo?room_id=6154037&protocol=0,1&format=0,1,2&codec=0,1&qn=150&platform=web&ptype=8&dolby=5&panorama=1
  ///https://api.live.bilibili.com/xlive/web-room/v2/index/getRoomPlayInfo?room_id=545068&protocol=0,1&format=0,1,2&codec=0,1&qn=250&platform=web&ptype=8&dolby=5&panorama=1
  ///
  static const String livePlayUrl =
      "$apiLiveBase/xlive/web-room/v2/index/getRoomPlayInfo";

  ///关注列表
  static const String followings = "$apiBase/x/relation/followings";

  ///粉丝列表
  static const String followers = "$apiBase/x/relation/followers";
}
