import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// relay a followers transform to a [relayTo]. Useful so we don't have to
// adjust a transform. Hopefully this works 😅
class FollowerPositionRelayerWithOverflowSafety extends MultiChildRenderObjectWidget {
  final CompositedTransformFollower follower;
  final Widget relayPosition;

  final Offset additionalOffset;

  FollowerPositionRelayerWithOverflowSafety(
      {super.key,
      required this.follower,
      required this.relayPosition,
      this.additionalOffset = Offset.zero})
      //order here matters: follower needs to come first or else!!!!!!!
      : super(children: [follower, relayPosition]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFollowerPositionRelayer(additionalOffset, MediaQuery.of(context).size);
  }

  @override
  RenderObject updateRenderObject(BuildContext context, RenderFollowerPositionRelayer renderObject) {
    return renderObject
      ..windowSize = MediaQuery.of(context).size
      ..additionalOffset = additionalOffset;
  }
}

/// MUST have the first child be a CompositedTransformFollower,
/// followed by an arbitrary second child that will be positioned at
/// the position of compositedTransformFollower.
class RenderFollowerPositionRelayer extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, StackParentData> {
  RenderFollowerPositionRelayer(this._additionalOffset, this._windowSize);


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

    final Offset secondChildPositionWithoutOverflowSafetyAdjustment =
        Offset(transformationMatrix.x, transformationMatrix.y) -
            Alignment.bottomCenter.alongSize(secondChildSize) + additionalOffset;

    

    final Offset positionSecondChildAt = Offset(
      secondChildPositionWithoutOverflowSafetyAdjustment.dx.clamp(0, windowSize.width - secondChildSize.width),
      secondChildPositionWithoutOverflowSafetyAdjustment.dy.clamp(0, windowSize.height - secondChildSize.height),
    );


    if (layer == null) {
      layer = OffsetLayer(offset: positionSecondChildAt);
    } else {
      layer!.offset = positionSecondChildAt;
    }



    //absolutely cursed
    context.pushLayer(layer!, lastChild!.paint, offset);
  }
}
