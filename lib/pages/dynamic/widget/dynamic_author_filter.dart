import 'package:bili_you/common/models/local/dynamic/dynamic_author.dart';
import 'package:bili_you/common/widget/avatar.dart';
import 'package:flutter/material.dart';

class DynamicAuthorFilter extends StatefulWidget {
  const DynamicAuthorFilter({super.key, required this.authors, this.onAuthorFilterApplied, this.height = 85, this.iconSize = 55});

  final double height;
  final double iconSize;
  final List<DynamicAuthor> authors;
  final void Function(int mid)? onAuthorFilterApplied;

  @override
  State<StatefulWidget> createState() => _DynamicAuthorFilter();
}

class _DynamicAuthorFilter extends State<DynamicAuthorFilter> {
  static const itemPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  final itemScrollController = ScrollController();
  int filterMid = 0;

  GestureTapCallback buildOnItemTapCallback(int index, DynamicAuthor author) {
    return () {
      if (filterMid == author.mid) {
        filterMid = 0;
      } else {
        filterMid = author.mid;
        author.hasUpdate = false;
        itemScrollController.animateTo((index + 0.5) * (widget.iconSize + itemPadding.horizontal) - (0.5 * MediaQuery.of(context).size.width),
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
      }
      setState(() {});
      widget.onAuthorFilterApplied?.call(filterMid);
    };
  }

  Widget buildAuthorListItem(int index, DynamicAuthor author) {
    return InkWell(
        onTap: buildOnItemTapCallback(index, author),
        child: Padding(
            padding: itemPadding,
            child: Opacity(
                opacity: filterMid == 0 || filterMid == author.mid ? 1.0 : 0.3,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Badge(
                      smallSize: 8,
                      alignment: AlignmentDirectional.bottomEnd,
                      isLabelVisible: author.hasUpdate,
                      child: AvatarWidget(
                        avatarUrl: author.avatarUrl,
                        radius: widget.iconSize / 2,
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SizedBox(
                          width: widget.iconSize,
                          child: Text(
                            author.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                          ))),
                ]))));
  }

  Widget buildAuthorList(BuildContext context) {
    return Container(
        height: widget.height,
        color: Theme.of(context).cardColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: itemScrollController,
          itemCount: widget.authors.length,
          itemBuilder: (context, index) => buildAuthorListItem(index, widget.authors[index]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: false,
      delegate: _SliverHeaderDelegate(height: widget.height, child: buildAuthorList(context)),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
