
class FilterCompositedFollowerPotentialBug extends StatelessWidget {
  static const Size lensSize = Size(200, 50);
  static const above = 40;

  final LayerLink link = LayerLink();
  final ValueNotifier<Offset> shouldPositionLensAt = ValueNotifier(Offset.zero);

  FilterCompositedFollowerPotentialBug({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// This gesture detector:
      /// 1. repositions the BDF lens
      /// 2. Positions the Target (and, as a corollary, the red follower)
      onPanUpdate: (details) => shouldPositionLensAt.value = Offset(
          details.globalPosition.dx, MediaQuery.of(context).size.height / 2),
      child: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.blue,
        ),

        /// Listens to the touch point and places the target where the touch point is
        ValueListenableBuilder(
          valueListenable: shouldPositionLensAt,
          builder: (_, offset, __) => Transform.translate(
            offset: offset,
            child: CompositedTransformTarget(
              link: link,
            ),
          ),
        ),
        // This follower is positioned directly at the touch point,
        // such that is always appears in the lens at the same position,
        // i.e. directly against the top edge of the lens
        CompositedTransformFollower(
          link: link,
          child: Container(
            color: Colors.red,
            width: 10,
            height: 10,
          ),
        ),

        /// The bdf lens.
        /// This should reflect what is immediately under it, i.e. the red square
        ValueListenableBuilder(
            valueListenable: shouldPositionLensAt,
            builder: (context, value, child) {
              Offset newOffset;

              // This logic just checks if we are pressed up against the left edge of the screen;
              // if we are, then make it so that the lens does not flow out of bounds
              if (value.dx - (lensSize.width / 2) < 0) {
                newOffset = Offset(lensSize.width / 2, value.dy);
              } else {
                newOffset = value;
              }

              return Positioned(
                top: newOffset.dy - lensSize.height - above,
                left: newOffset.dx - lensSize.width / 2,
                child: Stack(
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.matrix(
                          (Matrix4.identity()
                                ..translate(0.0, -lensSize.height - above))
                              .storage,
                        ),
                        child: SizedBox.fromSize(size: lensSize),
                      ),
                    ),
                    // Just for visualization purposes, this is a green border around the lens
                    // so we can see exactly where it is
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 3)),
                      child: SizedBox.fromSize(
                        size: lensSize,
                      ),
                    )
                  ],
                ),
              );
            })
      ]),
    );
  }
}
