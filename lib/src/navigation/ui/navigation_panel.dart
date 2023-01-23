import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../styled_widgets/smooth_scroll.dart';
import '../../utils/utils.dart';
import '../navigation.dart';

class NavigationPanel extends StatefulWidget {
  const NavigationPanel({
    Key? key,
    required this.pages,
    this.header,
  }) : super(key: key);

  final List<BookOrganizer> pages;
  final Widget? header;

  @override
  _NavigationPanelState createState() => _NavigationPanelState();
}

class _NavigationPanelState extends State<NavigationPanel> {
  final ScrollController controller = ScrollController();
  // ComponentState? selectedComponent;

  final TextEditingController search = TextEditingController();
  String query = '';

  /* void _onComponentSelected(ComponentState state) {
    ComponentState? current = state;
    if (current == selectedComponent) current = null;
    widget.onComponentSelected?.call(current);
    selectedComponent = current;
    setState(() {});
  } */

  List<Widget> tiles = [];

  @override
  void didChangeDependencies() {
    tiles.clear();
    for (var element in widget.pages) {
      tiles.add(
        _buildElement(element, 1),
      );
    }
    super.didChangeDependencies();
  }

  Widget _buildElement(BookOrganizer item, int level) {
    switch (item.type) {
      case OrganizerType.categoty:
        return _buildCategory(item as BookCategory);
      case OrganizerType.folder:
        return _buildFolder(item as BookFolder, level);
      case OrganizerType.page:
        return _buildPage(item as BookPage, level);
    }
  }

  Widget _buildCategory(
    final BookCategory item,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 12.0, bottom: 4, left: 24, right: 16),
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        ...item.organizers
            .map(
              (e) => _buildElement(e, 1),
            )
            .toList(),
      ],
    );
  }

  Widget _buildFolder(BookFolder folder, int layer) {
    double padding = layer * 8;
    return BookFolderTile(
      organizers: folder.organizers
          .map(
            (e) => _buildElement(e, layer + 1),
          )
          .toList(),
      padding: padding,
      item: folder,
    );
  }

  Widget _buildPage(BookPage page, int layer) {
    double padding = layer * 8;
    return BookPageTile(
      page: page,
      onSelected: (p0) {},
      isSelected: false,
      padding: padding,
    );
  }

  void _searchOrganizers(String query) {
    this.query = query;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50, maxWidth: 250),
      child: Column(
        children: [
          widget.header ?? const _NavigationHeader(),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => CupertinoSearchTextField(
                      itemSize: 16,
                      controller: search,
                      onChanged: _searchOrganizers,
                      onSuffixTap: () {
                        search.text = '';
                        _searchOrganizers('');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                // if (kIsWeb) {
                // If web, we just disable smooth scrolling.
                return ListView.separated(
                  controller: controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: tiles.length,
                  itemBuilder: (context, index) => tiles[index],
                  padding: const EdgeInsets.only(bottom: 8),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                );
                /*}  else {
                  // If windows or macos we can allow smooth scrolling.
                  if (Platform.isMacOS || Platform.isWindows) {
                    return SmoothScroll(
                      controller: controller,
                      curve: Curves.easeOutExpo,
                      scrollSpeed: 50,
                      child: ListView.separated(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.pages.length,
                        itemBuilder: _buildFolder,
                        padding: const EdgeInsets.only(bottom: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                      ),
                    );
                  } else {
                    // If it's mobile then we're not using smooth scrolling.
                    return ListView.separated(
                      controller: controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget.pages.length,
                      itemBuilder: _buildFolder,
                      padding: const EdgeInsets.only(bottom: 8),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                    );
                  } 
                } */
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  const _NavigationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(FeatherIcons.bookOpen, color: Color(0xFFD689EF)),
                const SizedBox(width: 8),
                Text(
                  'Flutterbook',
                  style: context.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(
            'by MOONSDONTBURN',
            style: context.textTheme.caption,
          ),
        ],
      ),
    );
  }
}
