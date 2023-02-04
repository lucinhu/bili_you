import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//视频进度条
class VideoProgressBar extends StatefulWidget {
  const VideoProgressBar({
    super.key,
    required this.videoController,
    required this.onDragEnd,
  });
  final VideoPlayerController videoController;
  final Function(Duration position) onDragEnd;

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar> {
  //视频位置(随视频更新)
  Duration sliderPosition = Duration.zero;
  //缓冲进度
  DurationRange buffered = DurationRange(Duration.zero, Duration.zero);
  //最大时长(毫秒)
  double max = 99999999999999;

  //是否已按下
  bool isClickDown = false;

  @override
  void initState() {
    //监听视频位置变化
    widget.videoController.addListener(() {
      //没有按下或拖动的时候才按视频进度进行更新
      if (!isClickDown) {
        sliderPosition = widget.videoController.value.position;
        if (widget.videoController.value.buffered.isNotEmpty) {
          buffered = widget.videoController.value.buffered.last;
        }
      } else {
        buffered = DurationRange(Duration.zero, Duration.zero);
      }
    });
    super.initState();
    //初始加载,解决初始有值的情况没有更新到(比如暂停然后切换到全屏的时候)
    max = widget.videoController.value.duration.inMilliseconds.toDouble();
    sliderPosition = widget.videoController.value.position;
    //判空是为了解决初始进入时controller.value.buffered数组中没有东西导致的报错
    if (widget.videoController.value.buffered.isNotEmpty) {
      buffered = widget.videoController.value.buffered.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: const SliderThemeData(trackHeight: 10, minThumbSeparation: 0),
      child: Slider(
        max: max,
        value: sliderPosition.inMilliseconds.toDouble(),
        secondaryTrackValue: buffered.end.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            //用手拖动时,按滑动位置更新
            sliderPosition = Duration(milliseconds: value.toInt());
          });
        },
        onChangeStart: (value) {
          //刚按下去时
          isClickDown = true;
        },
        onChangeEnd: (value) {
          //刚松开手时
          isClickDown = false;
          setState(() {
            //移动视频到滑动的位置
            widget.videoController.seekTo(sliderPosition);
            widget.onDragEnd(sliderPosition);
          });
        },
      ),
    );
  }
}
