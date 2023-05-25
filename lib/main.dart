import 'package:flutter/material.dart';

class AppUtils {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final context = navigatorKey.currentState?.context;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppUtils.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ParentView(title: 'Right Side Demo Flutter Web'),
    );
  }
}

// This is the parent view of the application.
// It contains the main scaffold and manages the right-side menu.

class ParentView extends StatefulWidget {
  const ParentView({super.key, required this.title});

  final String title;

  @override
  State<ParentView> createState() => _HomePage();
}

class _HomePage extends State<ParentView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // This is the child view, which is nested inside the parent view.
      // It occupies 80% of the parent's height.
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: ChildView(counter: _counter),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// This is the child view, which is nested inside the parent view.
// It occupies 80% of the parent's height.
class ChildView extends StatelessWidget {
  const ChildView({
    super.key,
    required int counter,
  }) : _counter = counter;

  final int _counter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      endDrawer: const Drawer(
        child: Align(child: Text('My Drawer')),
      ),
      onEndDrawerChanged: (va) {},
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                transitionDuration: const Duration(milliseconds: 500),
                barrierLabel: MaterialLocalizations.of(context).dialogLabel,

                // A function that returns the widget representing the content
                // of the dialog. This function is called whenever the dialog
                // needs to be rebuilt.
                pageBuilder: (_, __, ___) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: const Material(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Right Side Menu with showGeneralDialog',
                          ),
                        ),
                      ),
                    ),
                  );
                },

                // A function that allows customizing the transition animation
                // between the closed and open state of the dialog.
                // It takes the context, animation, and widget to animate as
                // parameters, and should return a widget that describes
                // the desired animation.
                transitionBuilder: (_, anim1, anim2, child) {
                  return SlideTransition(
                    position: CurvedAnimation(
                      parent: anim1,
                      curve: Curves.easeInOutCubic,
                    ).drive(
                      Tween(
                        begin: const Offset(1, 0),
                        end: const Offset(0, 0),
                      ),
                    ),
                    child: child,
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.menu),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
