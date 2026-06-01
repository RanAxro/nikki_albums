
import "../model/tree_node.dart";
import "package:nikki_albums/widgets/app/component.dart";
import "package:nikki_albums/widgets/common/component.dart";

import "package:flutter/material.dart";

import "package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart";


class TreeViewPage extends StatefulWidget{
  final Duration duration;
  final List<TreeNode> root;
  const TreeViewPage({
    super.key,
    this.duration = const Duration(milliseconds: 100),
    required this.root,
  });

  @override
  State<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage>{
  late TreeController<TreeNode> treeController;

  void initController(){
    treeController = TreeController<TreeNode>(
      roots: widget.root,
      childrenProvider: (node) => node.children,
      defaultExpansionState: false,
    );

    // 展开标记了 initiallyExpanded 的节点
    _expandDefaultNodes(widget.root);
  }

  @override
  void initState(){
    super.initState();
    initController();
  }

  @override
  void didUpdateWidget(TreeViewPage oldWidget){
    super.didUpdateWidget(oldWidget);

    if(widget.root != oldWidget.root){
      initController();
    }
  }

  /// 递归遍历，展开默认节点
  void _expandDefaultNodes(Iterable<TreeNode> nodes){
    for(final node in nodes){
      if(node.initiallyExpanded){
        treeController.expand(node);
      }
      if(node.children.isNotEmpty){
        _expandDefaultNodes(node.children);
      }
    }
  }

  @override
  void dispose(){
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SmoothPointerScroll(
      builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
        return AnimatedTreeView<TreeNode>(
          controller: controller,
          physics: physics,
          treeController: treeController,
          duration: widget.duration,
          nodeBuilder: (context, TreeEntry<TreeNode> entry){
            return TreeNodeTile(
              key: ValueKey(entry.node),
              entry: entry,
              onToggle: () => treeController.toggleExpansion(entry.node),
            );
          },
        );
      },
    );
  }
}

class TreeNodeTile extends StatelessWidget{
  const TreeNodeTile({
    super.key,
    required this.entry,
    required this.onToggle,
  });

  final TreeEntry<TreeNode> entry;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context){
    final node = entry.node;

    return AppButton.smallText(
      toolTip: node.tooltip,
      isTranslate: false,
      onClick: entry.hasChildren ? onToggle : node.onClick,
      child: TreeIndentation(
        entry: entry,
        guide: IndentGuide.scopingLines(
          indent: smallButtonSize,
          color: AppColorScheme.of(context).byRole(ColorRole.background).onDisabledColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: smallButtonSize,
                height: smallButtonSize,
                child: Center(
                  child: entry.hasChildren ? AnimatedRotation(
                    turns: entry.isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 100),
                    child: const Icon(
                      Icons.chevron_right,
                      size: smallButtonContentSize,
                      color: Colors.grey,
                    ),
                  ) : null,
                ),
              ),
              const SizedBox(width: 4),

              if(node.icon != null)
                SizedBox(
                  width: smallButtonSize,
                  height: smallButtonSize,
                  child: node.icon,
                ),
              if(node.icon != null)
                const SizedBox(width: 4),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(node.title, isTranslate: false, fontWeight: FontWeight.bold),
                    const SizedBox(width: 12),
                    if(node.message != null)
                      Expanded(
                        child: AppText(
                          node.message!,
                          isTranslate: false,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}