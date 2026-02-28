
import "package:easy_localization/easy_localization.dart";
import "package:nikkialbums/component/component.dart";
import "package:nikkialbums/ui/r_ui_info.dart";

import "image_addition.dart";

import "package:flutter/material.dart";

// ==================== 状态管理（分离 UI 与状态）====================

/// 树节点包装器 - 使用索引路径作为稳定标识
class _TreeNode {
  final Field field;
  final String indexPath; // 例如: "0", "0-2", "0-2-1" - 基于索引，不依赖Field内容

  const _TreeNode({
    required this.field,
    required this.indexPath,
  });
}

/// FieldTreeController - 使用索引路径管理状态
class FieldTreeController extends ChangeNotifier {
  final Set<String> _expandedPaths = {}; // 使用索引路径而非key
  final Map<String, String> _translationCache = {};
  Field _root;
  final int maxDepth;

  FieldTreeController({
    required Field root,
    this.maxDepth = 10,
  }) : _root = root {
    _initializeExpanded(_root, '');
  }

  Field get root => _root;

  /// 更新根节点 - 保持展开状态
  void updateRoot(Field newRoot) {
    _root = newRoot;
    // 清理不存在的路径（可选，保持已有路径的展开状态）
    _cleanupInvalidPaths();
    notifyListeners();
  }

  void _initializeExpanded(Field field, String indexPath) {
    if (field.expand) {
      _expandedPaths.add(indexPath);
    }
    for (var i = 0; i < field.children.length; i++) {
      _initializeExpanded(field.children[i], '$indexPath-$i');
    }
  }

  /// 清理无效路径（当节点结构变化时）
  void _cleanupInvalidPaths() {
    final validPaths = _collectValidPaths(_root, '');
    _expandedPaths.removeWhere((path) => !validPaths.contains(path));
  }

  Set<String> _collectValidPaths(Field field, String indexPath) {
    final paths = <String>{indexPath};
    for (var i = 0; i < field.children.length; i++) {
      paths.addAll(_collectValidPaths(field.children[i], '$indexPath-$i'));
    }
    return paths;
  }

  bool isExpanded(String indexPath) => _expandedPaths.contains(indexPath);

  void toggleExpand(String indexPath) {
    if (_expandedPaths.contains(indexPath)) {
      _expandedPaths.remove(indexPath);
    } else {
      _expandedPaths.add(indexPath);
    }
    notifyListeners();
  }

  void expandAll() {
    _expandAllRecursive(_root, '');
    notifyListeners();
  }

  void _expandAllRecursive(Field field, String indexPath) {
    _expandedPaths.add(indexPath);
    for (var i = 0; i < field.children.length; i++) {
      _expandAllRecursive(field.children[i], '$indexPath-$i');
    }
  }

  void collapseAll() {
    _expandedPaths.clear();
    notifyListeners();
  }

  String getTranslation(String key, bool shouldTranslate, List<String>? args) {
    if (!shouldTranslate) return key;

    final cacheKey = '$key-${args?.join(',') ?? ''}';
    return _translationCache.putIfAbsent(cacheKey, () => key.tr(args: args));
  }

  void clearCache() => _translationCache.clear();

  @override
  void dispose() {
    _translationCache.clear();
    _expandedPaths.clear();
    super.dispose();
  }
}

/// 配置类
class FieldTreeConfiguration {
  final EdgeInsets padding;
  final double indent;
  final Duration animationDuration;
  final Curve animationCurve;
  final BoxDecoration? itemDecoration;
  final BoxDecoration? expandedItemDecoration;
  final TextStyle? keyStyle;
  final TextStyle? valueStyle;
  final double iconSize;
  final Color? iconColor;
  final Color? expandIconColor;
  final Function(Field field)? onFieldTap;
  final bool showLeafValueOnly;
  final int maxDepth;
  final bool keepAlive;

  const FieldTreeConfiguration({
    this.padding = const EdgeInsets.all(16),
    this.indent = 24.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.itemDecoration,
    this.expandedItemDecoration,
    this.keyStyle,
    this.valueStyle,
    this.iconSize = 20,
    this.iconColor,
    this.expandIconColor,
    this.onFieldTap,
    this.showLeafValueOnly = false,
    this.maxDepth = 10,
    this.keepAlive = true,
  });
}

/// 高性能树节点组件
class _FieldNode extends StatefulWidget {
  final _TreeNode node;
  final int level;
  final FieldTreeController controller;
  final FieldTreeConfiguration config;

  const _FieldNode({
    super.key,
    required this.node,
    required this.level,
    required this.controller,
    required this.config,
  });

  @override
  State<_FieldNode> createState() => _FieldNodeState();
}

class _FieldNodeState extends State<_FieldNode>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  bool get wantKeepAlive => widget.config.keepAlive;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    widget.controller.addListener(_onControllerUpdate);
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: widget.config.animationDuration,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.config.animationCurve,
    ));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  bool get _isExpanded => widget.controller.isExpanded(widget.node.indexPath);

  void _onControllerUpdate() {
    final expanded = _isExpanded;
    if (expanded != (_animationController.status == AnimationStatus.completed)) {
      setState(() {
        if (expanded) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
  }

  @override
  void didUpdateWidget(_FieldNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 关键：如果索引路径变化，重新初始化动画状态
    if (oldWidget.node.indexPath != widget.node.indexPath) {
      _animationController.dispose();
      _initAnimation();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final field = widget.node.field;
    if (!field.visible) return const SizedBox.shrink();
    if (widget.level > widget.config.maxDepth) return const SizedBox.shrink();

    final hasChildren = field.children.isNotEmpty;
    final isExpanded = _isExpanded;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NodeItem(
            node: widget.node,
            level: widget.level,
            isExpanded: isExpanded,
            hasChildren: hasChildren,
            rotationAnimation: _rotationAnimation,
            config: widget.config,
            controller: widget.controller,
            onToggle: hasChildren ? _handleToggle : null,
          ),

          if (hasChildren)
            Visibility(
              visible: isExpanded,
              maintainState: widget.config.keepAlive,
              child: _ChildList(
                parentNode: widget.node,
                level: widget.level,
                controller: widget.controller,
                config: widget.config,
              ),
            ),
        ],
      ),
    );
  }

  void _handleToggle() {
    widget.controller.toggleExpand(widget.node.indexPath);
  }
}

/// 子节点列表
class _ChildList extends StatelessWidget {
  final _TreeNode parentNode;
  final int level;
  final FieldTreeController controller;
  final FieldTreeConfiguration config;

  const _ChildList({
    super.key,
    required this.parentNode,
    required this.level,
    required this.controller,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final children = parentNode.field.children;

    return Padding(
      padding: EdgeInsets.only(left: config.indent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          final child = children[index];
          final childPath = '${parentNode.indexPath}-$index';

          return _FieldNode(
            key: ValueKey(childPath), // 使用索引路径作为Key
            node: _TreeNode(
              field: child,
              indexPath: childPath,
            ),
            level: level + 1,
            controller: controller,
            config: config,
          );
        }),
      ),
    );
  }
}

/// 节点项
class _NodeItem extends StatelessWidget {
  final _TreeNode node;
  final int level;
  final bool isExpanded;
  final bool hasChildren;
  final Animation<double> rotationAnimation;
  final FieldTreeConfiguration config;
  final FieldTreeController controller;
  final VoidCallback? onToggle;

  const _NodeItem({
    super.key,
    required this.node,
    required this.level,
    required this.isExpanded,
    required this.hasChildren,
    required this.rotationAnimation,
    required this.config,
    required this.controller,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final field = node.field;

    final keyText = field.key == null ? "" : controller.getTranslation(
      field.stringKey,
      field.isTranslateKey,
      field.keyArgs,
    );

    final valueText = field.value == null ? "" : controller.getTranslation(
      field.stringValue,
      field.isTranslateValue,
      field.valueArgs,
    );

    return InkWell(
      onTap: onToggle ?? () => config.onFieldTap?.call(field),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: _getDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasChildren)
              RotationTransition(
                turns: rotationAnimation,
                child: Icon(
                  Icons.chevron_right,
                  size: config.iconSize,
                  color: config.expandIconColor ?? Colors.grey.shade600,
                ),
              )
            else
              SizedBox(width: config.iconSize),

            const SizedBox(width: 8),

            if (field.keyIcon != null) ...[
              _Icon(iconName: field.keyIcon!, config: config),
              const SizedBox(width: 8),
            ],

            Expanded(
              flex: 2,
              child: Text(
                keyText,
                style: config.keyStyle?.copyWith(
                  fontWeight: hasChildren ? FontWeight.w600 : FontWeight.normal,
                ) ??
                    TextStyle(
                      fontWeight: hasChildren ? FontWeight.w600 : FontWeight.normal,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (!config.showLeafValueOnly || field.children.isEmpty) ...[
              const SizedBox(width: 16),
              if (field.valueIcon != null) ...[
                _Icon(iconName: field.valueIcon!, config: config),
                const SizedBox(width: 4),
              ],
              Expanded(
                flex: 3,
                child: Text(
                  valueText,
                  style: config.valueStyle ?? TextStyle(color: Colors.grey.shade600),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration? _getDecoration() {
    if (isExpanded && config.expandedItemDecoration != null) {
      return config.expandedItemDecoration;
    }
    return config.itemDecoration;
  }
}

/// 图标组件
class _Icon extends StatelessWidget {
  final String iconName;
  final FieldTreeConfiguration config;

  const _Icon({required this.iconName, required this.config});

  static final Map<String, IconData> _iconCache = {
    'folder': Icons.folder,
    'folder_open': Icons.folder_open,
    'file': Icons.insert_drive_file,
    'pdf': Icons.picture_as_pdf,
    'image': Icons.image,
    'video': Icons.video_file,
    'audio': Icons.audio_file,
    'code': Icons.code,
    'text': Icons.text_snippet,
    'link': Icons.link,
    'person': Icons.person,
    'email': Icons.email,
    'phone': Icons.phone,
    'location': Icons.location_on,
    'date': Icons.calendar_today,
    'time': Icons.access_time,
    'money': Icons.attach_money,
    'settings': Icons.settings,
    'info': Icons.info,
    'warning': Icons.warning,
    'error': Icons.error,
    'check': Icons.check_circle,
    'close': Icons.cancel,
    'add': Icons.add_circle,
    'remove': Icons.remove_circle,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'share': Icons.share,
    'download': Icons.download,
    'upload': Icons.upload,
    'star': Icons.star,
    'favorite': Icons.favorite,
    'home': Icons.home,
    'work': Icons.work,
    'school': Icons.school,
  };

  @override
  Widget build(BuildContext context) {
    return Icon(
      _iconCache[iconName.toLowerCase()] ?? Icons.label_outline,
      size: config.iconSize,
      color: config.iconColor ?? Colors.grey.shade600,
    );
  }
}

/// FieldTree 主组件
class FieldTree extends StatefulWidget {
  final Field root;
  final FieldTreeConfiguration config;
  final FieldTreeController? controller;

  const FieldTree({
    super.key,
    required this.root,
    this.config = const FieldTreeConfiguration(),
    this.controller,
  });

  @override
  State<FieldTree> createState() => _FieldTreeState();
}

class _FieldTreeState extends State<FieldTree> {
  late FieldTreeController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = FieldTreeController(
        root: widget.root,
        maxDepth: widget.config.maxDepth,
      );
      _isInternalController = true;
    }
  }

  @override
  void didUpdateWidget(FieldTree oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 关键：Field 变化时，使用 controller.updateRoot 而非重建 controller
    if (widget.controller == null) {
      // 外部没有提供 controller，使用内部的
      if (_isInternalController) {
        // 检查 Field 是否真的变化
        if (!_areFieldsEqual(oldWidget.root, widget.root)) {
          _controller.updateRoot(widget.root);
        }
      } else {
        // 之前是外部的，现在变成内部的（不太可能，但处理一下）
        _initController();
      }
    } else {
      // 外部提供了 controller，更新其 root
      if (widget.controller != oldWidget.controller) {
        _controller = widget.controller!;
        _isInternalController = false;
      }
      if (!_areFieldsEqual(_controller.root, widget.root)) {
        _controller.updateRoot(widget.root);
      }
    }
  }

  /// 深度比较两个 Field 是否相等
  bool _areFieldsEqual(Field a, Field b) {
    if (identical(a, b)) return true;
    if (a.stringKey != b.stringKey) return false;
    if (a.stringValue != b.stringValue) return false;
    if (a.visible != b.visible) return false;
    if (a.children.length != b.children.length) return false;

    for (var i = 0; i < a.children.length; i++) {
      if (!_areFieldsEqual(a.children[i], b.children[i])) return false;
    }
    return true;
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return SmoothPointerScroll(
          builder: (BuildContext context, ScrollController controller, ScrollPhysics physics, IndependentScrollbarController scrollbarController){
            return SingleChildScrollView(
              controller: controller,
              physics: physics,
              padding: widget.config.padding,
              child: _FieldNode(
                node: _TreeNode(
                  field: _controller.root,
                  indexPath: '', // 根节点路径为空
                ),
                level: 0,
                controller: _controller,
                config: widget.config,
              ),
            );
          },
        );
      },
    );
  }
}











