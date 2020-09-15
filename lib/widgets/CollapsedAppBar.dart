import 'package:flutter/material.dart';

class CollapsedAppBar extends StatefulWidget {
  Widget bodyWidget;
  FloatingActionButton fab;
  String imageUrl;
  bool showFab = true;

  CollapsedAppBar({this.bodyWidget, this.fab, this.imageUrl, this.showFab});

  @override
  _CollapsedAppBarState createState() => _CollapsedAppBarState();
}

class _CollapsedAppBarState extends State<CollapsedAppBar> {
  final scrollController = new ScrollController();
  final double _height = 290.0;

  @override
  void initState() {
    scrollController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new NestedScrollView(
            controller: scrollController,
            body: SingleChildScrollView(child: widget.bodyWidget),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: _height,
                  pinned: false,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: (widget.imageUrl != null && widget.imageUrl != 'null')
                        ? Image.network(widget.imageUrl, fit: BoxFit.cover)
                        : Image.asset('assets/images/solar_panel.png', fit: BoxFit.cover),
                  ),
                ),
              ];
            }
        ),
        (widget.showFab) ? _buildFloatingActionButton() : Container(),
      ],
    );
  }

  Positioned _buildFloatingActionButton() {
    final defaultTopMargin = _height - 9.0;
    final startScale = 96.0;
    final endScale = startScale / 2;

    var top = defaultTopMargin;
    var scale = 1.0;

    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - startScale) {
        scale = 1.0;
      } else if (offset < defaultTopMargin - endScale) {
        scale = (defaultTopMargin - endScale - offset) / endScale;
      } else {
        scale = 0.0;
      }
    }

    return new Positioned(
      child: new Transform.scale(
          scale: scale,
          child: widget.fab
      ),
      top: top,
      right: 24.0,
    );
  }
}
