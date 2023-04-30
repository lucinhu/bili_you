class VideoPlayItem {
  VideoPlayItem({
    required this.urls,
    required this.quality,
    required this.bandWidth,
    required this.codecs,
    required this.width,
    required this.height,
    required this.frameRate,
    // required this.mimeType,
    // required this.segmentBase,
    required this.sar,
    // required this.timeLength
  });

  static VideoPlayItem get zero => VideoPlayItem(
        urls: [],
        quality: VideoQuality.unknown,
        bandWidth: 0,
        codecs: "",
        width: 0,
        height: 0,
        frameRate: 0,
        // mimeType: '',
        // segmentBase: SegmentBase(indexRange: '', initialization: ''),
        sar: 1 / 1,
        // timeLength: 0
      );

  ///清晰度
  VideoQuality quality;

  ///视频流链接
  List<String> urls;

  ///所需最低带宽byte
  int bandWidth;

  ///编码类型
  String codecs;

  ///宽度
  int width;

  ///高度
  int height;

  ///帧率
  double frameRate;

  // String mimeType;

  // SegmentBase segmentBase;

  double sar;

  // //时长,秒为单位
  // int timeLength;
}

class SegmentBase {
  SegmentBase({required this.initialization, required this.indexRange});
  String initialization = '';
  String indexRange = '';
}

enum VideoQuality {
  unknown,
  topSpeed240p,
  fluent360p,
  clear480p,
  high720p,
  high720p60,
  high1080p,
  high1080pPlus,
  high1080p60,
  super4k,
  hdr,
  dolbyVision,
  super8k
}

extension VideoQualityCode on VideoQuality {
  static final List<int> _codeList = [
    -1,
    6,
    16,
    32,
    64,
    74,
    80,
    112,
    116,
    120,
    125,
    126,
    127,
  ];

  //根据code构造VideoQuality，如果没有匹配成功，则返回VideoQuality.unknown;
  static VideoQuality fromCode(int code) {
    var index = _codeList.indexOf(code);
    //如果找不到的话，返回VideoQuality.unknown
    if (index == -1) {
      return VideoQuality.unknown;
    }
    return VideoQuality.values[index];
  }

  int get code => _codeList[index];
}

extension VideoQualityDescription on VideoQuality {
  get description => [
        '未知',
        '240P 极速',
        '360P 流畅',
        '480P 清晰',
        '720P 高清',
        '720P 高帧率',
        '1080P 高清',
        '1080P+ 高码率',
        '1080P60 高帧率',
        '4K 超清',
        'HDR 真彩色',
        '杜比视界',
        '8K 超高清'
      ][index];
}
