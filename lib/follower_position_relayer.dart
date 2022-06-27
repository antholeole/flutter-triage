import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// relay a followers transform to a [relayTo]. Useful so we don't have to
// adjust a transform. Hopefully this works 😅
class AnimatedCompositedTransformFollowerWithSafeArea
    extends MultiChildRenderObjectWidget {
  final Widget child;
  final Offset offset;

  AnimatedCompositedTransformFollowerWithSafeArea(
      {super.key,
      required LayerLink link,
      required this.child,
      this.offset = Offset.zero})
      //order here matters: follower needs to come first or else!!!!!!!
      : super(children: [
          CompositedTransformFollower(
            link: link,
          ),
          child //wrap me with inhereted?
        ]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAnimatedCompositedTransformFollowerWithSafeArea(
        offset, MediaQuery.of(context).size);
  }

  @override
  RenderObject updateRenderObject(
      BuildContext context, RenderAnimatedCompositedTransformFollowerWithSafeArea renderObject) {
    return renderObject
      ..windowSize = MediaQuery.of(context).size
      ..additionalOffset = offset;
  }
}

/// MUST have the first child be a CompositedTransformFollower,
/// followed by an arbitrary second child that will be positioned at
/// the position of compositedTransformFollower.
class RenderAnimatedCompositedTransformFollowerWithSafeArea extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, StackParentData> {
  RenderAnimatedCompositedTransformFollowerWithSafeArea(this._additionalOffset, this._windowSize);

  Size get windowSize => _windowSize;
  Size _windowSize;
  set windowSize(Size value) {
    if (_windowSize == value) {
      return;
    }
    _windowSize = value;
    markNeedsLayout();
  }

  Offset get additionalOffset => _additionalOffset;
  Offset _additionalOffset;
  set additionalOffset(Offset value) {
    if (_additionalOffset == value) {
      return;
    }
    _additionalOffset = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    firstChild!.layout(constraints);
    lastChild!.layout(constraints);
    size = constraints.biggest;
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! StackParentData) {
      child.parentData = StackParentData();
    }
  }

  @override
  OffsetLayer? get layer => super.layer as OffsetLayer?;

  @override
  void paint(PaintingContext context, Offset offset) {
    //this is the darkhold
    firstChild!.paint(context, offset);

    RenderFollowerLayer followerLayer = firstChild! as RenderFollowerLayer;
    followerLayer.offset = Offset.zero;
    final transformationMatrix =
        followerLayer.getCurrentTransform().getTranslation();

    final secondChildSize = lastChild!.size;

    final Offset unadjustedSecondChildPosition =
        Offset(transformationMatrix.x, transformationMatrix.y) -
            Alignment.bottomCenter.alongSize(secondChildSize) +
            additionalOffset;

    final Offset adjustedSecondChildPosition = Offset(
      unadjustedSecondChildPosition.dx
          .clamp(0, windowSize.width - secondChildSize.width),
      unadjustedSecondChildPosition.dy
          .clamp(0, windowSize.height - secondChildSize.height),
    );

    if (layer == null) {
      layer = OffsetLayer(offset: adjustedSecondChildPosition);
    } else {
      layer!.offset = adjustedSecondChildPosition;
    } 

    //absolutely cursed
    context.pushLayer(layer!, lastChild!.paint, offset);
  }
}
