import 'package:flutter/material.dart';
import 'package:xayn_architecture/xayn_architecture_navigation.dart' as xayn;
import 'package:xayn_architecture_example/dependency_config.dart';

class PageRegistry {
  static final pageIncrement = xayn.PageData(
    isInitial: true,
    name: "pageIncrement",
    builder: (_, args) => PageIncrement(
      argument: args,
    ),
    arguments: 1,
  );
  static final pageDialog = xayn.PageData(
    name: "pageDialog",
    builder: (_, args) => PageDialog(
      argument: args,
    ),
    arguments: 1,
  );

  static final Set<xayn.UntypedPageData> pages = {pageIncrement, pageDialog};
  static final Map<String, xayn.UntypedPageData> pageMap =
      Map.fromEntries(pages.map((e) => MapEntry(e.isInitial ? "" : e.name, e)));
}

abstract class PageIncrementExitActions {
  void onPlusButtonClicked(int argument);

  Future<int?> onPlusButtonClickedForResult(int argument);
}

class PageIncrement extends StatelessWidget {
  final int? argument;

  const PageIncrement({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageIncrementExitActions exitActions = di.get();
    final count = argument ?? 0;
    return Scaffold(
      body: Center(child: Text("page $count")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (count.isEven) {
            exitActions.onPlusButtonClicked(count + 1);
          } else {
            final res =
                await exitActions.onPlusButtonClickedForResult(count + 1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Received $res"),
            ));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract class PageDialogExitActions {
  void onPlusButtonClicked(int argument);

  void onSubmittedResult(int result);
}

class PageDialog extends StatelessWidget {
  final int? argument;

  const PageDialog({Key? key, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageDialogExitActions exitActions = di.get();
    final count = argument ?? 0;
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("page $argument"),
          TextButton(
              onPressed: () {
                exitActions.onSubmittedResult(count);
              },
              child: Text("Close and Send back $count")),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          exitActions.onPlusButtonClicked(count + 1);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
