import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../styled_widgets/highlighter.dart';
import '../../utils/utils.dart';
import '../models/organizers.dart';

//ignore_for_file: must_call_super

class BookPageTile extends StatefulWidget {
  const BookPageTile({
    Key? key,
    required this.onSelected,
    required this.padding,
    required this.page,
    this.isSelected = false,
  }) : super(key: key);

  final void Function(BookPage page) onSelected;

  final double padding;
  final BookPage page;

  final bool isSelected;

  @override
  _BookPageTileState createState() => _BookPageTileState();
}

class _BookPageTileState extends State<BookPageTile>
    with AutomaticKeepAliveClientMixin {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = widget.isSelected
        ? context.colorScheme.primary
        : context.colorScheme.onSurface;

    return Highlighter(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      color:
          context.colorScheme.primary.withOpacity(widget.isSelected ? 1 : 0.3),
      overrideHover: widget.isSelected,
      onPressed: () => widget.onSelected(widget.page),
      child: Container(
        padding: EdgeInsets.fromLTRB(widget.padding, 4, 16, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 16),
            Icon(
              widget.isSelected ? FeatherIcons.bookOpen : FeatherIcons.book,
              size: 14,
              color: widget.isSelected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.page.name,
                style: context.textTheme.bodyText1!.copyWith(color: hoverColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookFolderTile extends StatefulWidget {
  const BookFolderTile({
    Key? key,
    required this.organizers,
    required this.item,
    required this.padding,
  }) : super(key: key);

  final List<Widget> organizers;
  final double padding;
  final BookOrganizer item;

  @override
  _BookFolderTileState createState() => _BookFolderTileState();
}

class _BookFolderTileState extends State<BookFolderTile>
    with AutomaticKeepAliveClientMixin {
  bool expanded = false;
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Highlighter(
          onEnter: (_) => setState(() => hover = true),
          onExit: (_) => setState(() => hover = false),
          onPressed: () => setState(() => expanded = !expanded),
          color: context.colorScheme.primary.withOpacity(0.3),
          child: Container(
            padding: EdgeInsets.fromLTRB(widget.padding, 4, 16, 4),
            child: Row(
              children: [
                if (widget.organizers.isNotEmpty)
                  Icon(
                    expanded
                        ? FeatherIcons.chevronDown
                        : FeatherIcons.chevronRight,
                    size: 12,
                    color: context.colorScheme.onSurface,
                  )
                else
                  const SizedBox(width: 12),
                const SizedBox(width: 4),
                Icon(
                  FeatherIcons.folder,
                  size: 14,
                  color: context.colorScheme.onSurface,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyText1!.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /* const SizedBox(width: 16),
            const SizedBox(width: 8), */
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: expanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.organizers,
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
