import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedCursorState {
  const AnimatedCursorState({
    this.offset = Offset.zero,
    this.size = kDefaultSize,
    this.size2 = kDefaultSize1,
    this.decoration = kDefaultDecoration,
  });

  static const Size kDefaultSize = Size(15, 15);
  static const Size kDefaultSize1 = Size(30, 30);
  static const BoxDecoration kDefaultDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(90)),
    color: Colors.black12,
  );

  final BoxDecoration decoration;
  final Offset offset;
  final Size size;
  final Size size2;
}

class AnimatedCursorProvider extends ChangeNotifier {
  AnimatedCursorProvider();

  AnimatedCursorState state = const AnimatedCursorState();

  void changeCursor(GlobalKey key, {BoxDecoration? decoration}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    state = AnimatedCursorState(
      size: renderBox.size,
      size2: renderBox.size,
      offset: renderBox.localToGlobal(Offset.zero).translate(renderBox.size.width / 2,
          renderBox.size.height / 2), decoration: decoration ?? AnimatedCursorState.kDefaultDecoration,
    );
    notifyListeners();
  }

  void resetCursor() {
    state = const AnimatedCursorState();
    notifyListeners();
  }

  void updateCursorPosition(Offset pos) {
    state = AnimatedCursorState(offset: pos);
    notifyListeners();
  }
}

class AnimatedCursor extends StatelessWidget {
  const AnimatedCursor({Key? key, this.child}) : super(key: key);

  final Widget? child;

  void _onCursorUpdate(PointerEvent event, BuildContext context) => context
      .read<AnimatedCursorProvider>()
      .updateCursorPosition(event.position);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedCursorProvider(),
      child: Consumer<AnimatedCursorProvider>(
        child: child,
        builder: (context, provider, child) {
          final state = provider.state;

          return Stack(
            children: [
              if (child != null) child,
              Positioned.fill(
                child: MouseRegion(
                  opaque: false,
                  onHover: (e) => _onCursorUpdate(e, context),
                ),
              ),
              Visibility(
                visible: state.offset != Offset.zero&& state.size != state.size2,
                child: AnimatedPositioned(
                    left: state.offset.dx - state.size.width / 1,
                    top: state.offset.dy - state.size.height / 1,
                    width: state.size2.width,
                    height: state.size2.height,
                    duration: const Duration(milliseconds: 100),
                    child: Center(
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black54, width: 1),
                        ),
                      ),
                    )),
              ),
              Visibility(
                visible: state.offset != Offset.zero,
                child: AnimatedPositioned(
                    left: state.offset.dx - state.size.width / 2,
                    top: state.offset.dy - state.size.height / 2,
                    width: state.size.width,
                    height: state.size.height,
                    duration: const Duration(milliseconds: 2),
                    child: Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedCursorMouseRegion extends StatefulWidget {
  const AnimatedCursorMouseRegion({Key? key, this.child, this.decoration})
      : super(key: key);

  final Widget? child;
  final BoxDecoration? decoration;

  @override
  _AnimatedCursorMouseRegionState createState() =>
      _AnimatedCursorMouseRegionState();
}

class _AnimatedCursorMouseRegionState extends State<AnimatedCursorMouseRegion> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnimatedCursorProvider>();

    return MouseRegion(
      key: _key,
      opaque: false,
      onHover: (_) => cubit.changeCursor(_key, decoration: widget.decoration),
      onExit: (_) => cubit.resetCursor(),
      child: widget.child,
    );
  }
}
