// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math_64.dart'; // 需要添加 dependency: vector_math: ^2.1.0
//
// /// TransformedBoundsBox
// /// 计算一个Widget在应用Matrix4变换后的最小包围盒大小，并返回一个该大小的SizedBox。
// /// 同时，SizedBox内部的子Widget也会应用相同的变换，并正确居中或对齐。
// class TransformedBoundsBox extends StatelessWidget {
//   final Widget child;
//   final Matrix4 transform;
//   final AlignmentGeometry transformAlignment; // 变换的对齐点，默认为Alignment.center
//
//   const TransformedBoundsBox({
//     super.key,
//     required this.child,
//     required this.transform,
//     this.transformAlignment = Alignment.center, // Transform widget的默认alignment是center
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomSingleChildLayout(
//       delegate: _TransformedLayoutDelegate(
//         transform: transform,
//         transformAlignment: transformAlignment,
//       ),
//       // CustomSingleChildLayout的child是Transform widget，
//       // 它会应用实际的视觉变换。
//       // _TransformedLayoutDelegate会测量这个Transform widget的未变换内容大小，
//       // 并计算出变换后的整体包围盒大小，然后定位这个Transform widget。
//       child: Transform(
//         transform: transform,
//         alignment: transformAlignment,
//         child: child, // 这是用户传入的原始子Widget
//       ),
//     );
//   }
// }
//
// /// 自定义布局代理，用于计算和定位变换后的Widget。
// class _TransformedLayoutDelegate extends SingleChildLayoutDelegate {
//   final Matrix4 transform;
//   final AlignmentGeometry transformAlignment;
//
//   // 用于在getDryLayout和performLayout之间传递计算结果，避免重复计算
//   Size? _transformedBoundingBoxSize;
//   Offset? _minTransformedOffset; // 变换后内容的最左上角偏移量
//
//   _TransformedLayoutDelegate({
//     required this.transform,
//     required this.transformAlignment,
//   });
//
//   /// 计算子Widget在应用Matrix4变换后的最小包围盒大小和其起始偏移。
//   /// [childSize] 是未变换前的子Widget的原始大小。
//   /// 返回值是一个元组：(变换后的包围盒大小, 变换后的内容最左上角的偏移)。
//   (Size, Offset) _calculateTransformedBounds(Size childSize) {
//     if (childSize.isEmpty) {
//       return (Size.zero, Offset.zero);
//     }
//
//     // 获取原始子Widget的四个角点
//     final List<Offset> corners = [
//       Offset.zero,
//       Offset(childSize.width, 0),
//       Offset(0, childSize.height),
//       Offset(childSize.width, childSize.height),
//     ];
//
//     // 计算变换的枢轴点（pivot point）相对于子Widget的局部坐标系。
//     // transformAlignment是一个AlignmentGeometry，它将一个矩形框（这里是childSize）
//     // 的某个点映射到(0,0)-(1,1)的规范化坐标系。
//     // x = (alignment.x + 1) / 2 * width
//     // y = (alignment.y + 1) / 2 * height
//     final double pivotX = (transformAlignment.x + 1) / 2 * childSize.width;
//     final double pivotY = (transformAlignment.y + 1) / 2 * childSize.height;
//
//     // 创建一个包含对齐点的复合变换矩阵。
//     // 1. 先将枢轴点平移到(0,0)。
//     // 2. 应用用户提供的变换矩阵。
//     // 3. 再将枢轴点平移回原来的位置。
//     final Matrix4 alignedTransform = Matrix4.identity()
//       ..translate(pivotX, pivotY)
//       ..multiply(transform)
//       ..translate(-pivotX, -pivotY);
//
//     double minX = double.infinity;
//     double minY = double.infinity;
//     double maxX = -double.infinity;
//     double maxY = -double.infinity;
//
//     // 遍历变换后的所有角点，找出其最小/最大X/Y坐标
//     for (var corner in corners) {
//       // 将Offset转换为Vector4进行Matrix4变换
//       final Vector4 v = alignedTransform.transform(Vector4(corner.dx, corner.dy, 0, 1));
//       final Offset transformedCorner = Offset(v.x, v.y); // 假设Z轴深度不影响2D包围盒
//
//       minX = min(minX, transformedCorner.dx);
//       minY = min(minY, transformedCorner.dy);
//       maxX = max(maxX, transformedCorner.dx);
//       maxY = max(maxY, transformedCorner.dx);
//     }
//
//     final transformedWidth = maxX - minX;
//     final transformedHeight = maxY - minY;
//
//     return (Size(transformedWidth, transformedHeight), Offset(minX, minY));
//   }
//
//   @override
//   Size getDryLayout(BoxConstraints constraints) {
//     // getDryLayout用于在实际布局前，根据给定的约束进行“干式”布局计算大小。
//     // 我们需要测量子Widget（即Transform widget）的原始大小。
//     // Transform widget本身并不会改变其报告的尺寸，它报告的是其child的尺寸。
//     // 所以我们用宽松的约束来测量它，获取其“固有”大小。
//     final BoxConstraints childConstraints = BoxConstraints.loose(const Size(double.infinity, double.infinity));
//     final Size childSize = layoutChild(0, childConstraints); // 测量Transform widget的原始内容大小
//
//     // 计算变换后的包围盒大小和偏移
//     final (size, minOffset) = _calculateTransformedBounds(childSize);
//     _transformedBoundingBoxSize = size;
//     _minTransformedOffset = minOffset;
//
//     return size; // 返回计算出的变换后包围盒的大小，作为TransformedBoundsBox的最终尺寸
//   }
//
//   @override
//   void performLayout(Size size, Size childSize) {
//     // performLayout进行实际的布局操作。
//     // 这里，`size` 是由getDryLayout返回的我们组件的最终尺寸。
//     // `childSize` 是子Widget（即Transform widget）的原始尺寸。
//
//     // 如果getDryLayout没有执行或结果丢失，再次计算（作为安全措施）。
//     if (_transformedBoundingBoxSize == null || _minTransformedOffset == null) {
//       getDryLayout(BoxConstraints.loose(childSize));
//     }
//
//     // 关键步骤：定位子Widget。
//     // 我们需要将Transform widget放置在一个偏移位置，
//     // 使得其内部的变换内容，在绘制后，其左上角（_minTransformedOffset）
//     // 正好位于我们这个TransformedBoundsBox的(0,0)位置。
//     // 这意味着Transform widget本身需要向反方向移动 _minTransformedOffset。
//     positionChild(0, Offset(-_minTransformedOffset!.dx, -_minTransformedOffset!.dy));
//   }
//
//   @override
//   bool shouldRelayout(_TransformedLayoutDelegate oldDelegate) {
//     // 检查是否需要重新布局。
//     // 当变换矩阵或对齐方式发生变化时，需要重新计算。
//     return oldDelegate.transform != transform ||
//         oldDelegate.transformAlignment != transformAlignment;
//   }
// }