import 'package:example/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbook/flutterbook.dart';

void main() {
  runApp(const Storyboard());
}

class Storyboard extends StatelessWidget {
  const Storyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterBook(
      themes: Themes.themes,
      pages: [
        BookCategory(
          folderName: 'LIBRARY',
          organizers: [
            BookFolder(
              folderName: 'Charts',
              pages: [
                BookPage(
                  pageName: 'LineGraph',
                  page: Container(),
                ),
                BookPage(
                  pageName: 'StackedGraph',
                  page: Container(),
                ),
              ],
            ),
            BookPage(
              pageName: 'Button',
              page: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CupertinoButton(
                    color: Colors.red,
                    onPressed: () {},
                    child: Text('Hello World'),
                  ),
                ),
              ),
            ),
          ],
        ),
        BookFolder(
          folderName: 'Charts',
          pages: [
            BookPage(
              pageName: 'LineGraph',
              page: Container(),
            ),
          ],
        ),
        BookPage(
          pageName: 'Button',
          page: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CupertinoButton(
                color: Colors.red,
                onPressed: () {},
                child: Text('Hello World'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
