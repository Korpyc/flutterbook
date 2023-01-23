import 'package:flutter/widgets.dart';

abstract class BookOrganizer {
  final String name;
  final List<BookOrganizer> organizers;
  final OrganizerType type;
  BookOrganizer? parent;

  /// Abstract class for organizer panel in the left.
  BookOrganizer({
    required this.name,
    required this.organizers,
    required this.type,
  });
}

enum OrganizerType { categoty, folder, page }

/// support only nested folders and pages
class BookCategory extends BookOrganizer {
  BookCategory({
    required String folderName,
    required List<BookOrganizer> organizers,
  })  : assert(
          organizers.any(
            (element) => element is BookFolder || element is BookPage,
          ),
        ),
        super(
          name: folderName,
          organizers: organizers,
          type: OrganizerType.categoty,
        ) {
    for (final BookOrganizer organizer in organizers) {
      organizer.parent = this;
    }
  }
}

class BookFolder extends BookOrganizer {
  BookFolder({
    required String folderName,
    required List<BookPage> pages,
  })  : assert(pages.isNotEmpty),
        super(
          name: folderName,
          organizers: pages,
          type: OrganizerType.folder,
        ) {
    for (final BookOrganizer organizer in pages) {
      organizer.parent = this;
    }
  }
}

class BookPage extends BookOrganizer {
  final String pageName;
  final Widget page;

  BookPage({
    required this.pageName,
    required this.page,
  }) : super(
          name: pageName,
          type: OrganizerType.page,
          organizers: [],
        );
}

/* class ComponentState {
  Component? parent;
  final String? markdown;
  final String stateName;
  final String? codeSample;
  final Widget Function(BuildContext, ControlsInterface) builder;

  String get path {
    String path = ReCase(stateName).paramCase;
    Organizer? currentParent = parent;
    while (currentParent != null) {
      path = '${ReCase(currentParent.name).paramCase}${'/$path'}';
      currentParent = currentParent.parent;
    }
    return path;
  }

  ComponentState({
    required this.builder,
    required this.stateName,
    this.markdown,
    this.codeSample,
  });

  factory ComponentState.center({
    required Widget child,
    String? markdown,
    String? codeSample,
    required String stateName,
  }) =>
      ComponentState(
        builder: (_, __) => Center(child: child),
        markdown: markdown,
        stateName: stateName,
        codeSample: codeSample,
      );

  factory ComponentState.child({
    required Widget child,
    String? markdown,
    String? codeSample,
    required String stateName,
  }) =>
      ComponentState(
        builder: (_, __) => child,
        markdown: markdown,
        stateName: stateName,
        codeSample: codeSample,
      );
} */

class ListItem<T> {
  final String title;
  final T value;
  ListItem({
    required this.title,
    required this.value,
  });
}
