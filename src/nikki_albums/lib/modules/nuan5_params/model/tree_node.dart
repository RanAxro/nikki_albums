import "package:flutter/material.dart";

class TreeNode{
  final String? tooltip;
  final Widget? icon;
  final String title;
  final String? message;
  final void Function(BuildContext)? onClick;
  final Iterable<TreeNode> children;
  final bool initiallyExpanded;

  const TreeNode({
    this.tooltip,
    this.icon,
    required this.title,
    this.message,
    this.onClick,
    this.children = const [],
    this.initiallyExpanded = false,
  });
}