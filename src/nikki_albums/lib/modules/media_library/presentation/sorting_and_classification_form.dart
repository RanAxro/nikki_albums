
import "../domain/item.dart";
import "../domain/library_controller.dart";
import "../model/sorting_method.dart";
import "../model/classification_standard.dart";

import "package:flutter/widgets.dart";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:forui/forui.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";


class SortingAndClassificationForm<T extends MediaItem, C extends SortAndClassificationMixin<T>> extends HookConsumerWidget{
  final Object? selectGroupId;
  final C controller;

  const SortingAndClassificationForm({
    super.key,
    this.selectGroupId,
    required this.controller,
  });

  static final Map<SortingMethod<MediaItem>, String> _sortingMethodTrKey = <SortingMethod<MediaItem>, String>{
    SortingMethod<MediaItem>.random(): "media_library.sorting_and_classification_form.sorting_method_random",
    SortingMethod<MediaItem>.none(): "media_library.sorting_and_classification_form.sorting_method_none",
    SortingMethod<MediaItem>.cTime(): Platform.isWindows
      ? "media_library.sorting_and_classification_form.sorting_method_creation"
      : "media_library.sorting_and_classification_form.sorting_method_changed",
    SortingMethod<MediaItem>.mTime(): "media_library.sorting_and_classification_form.sorting_method_modified",
    SortingMethod<MediaItem>.size(): "media_library.sorting_and_classification_form.sorting_method_size",
  };

  static final Map<ClassificationStandard, String> _classificationStandardTrKey = <ClassificationStandard, String>{
    ClassificationStandard.year: "media_library.sorting_and_classification_form.classification_standard_year",
    ClassificationStandard.month: "media_library.sorting_and_classification_form.classification_standard_month",
    ClassificationStandard.day: "media_library.sorting_and_classification_form.classification_standard_day",
  };

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final Widget child = ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _){
        final Widget sortingMethodForm = Row(
          spacing: 8,
          children: <Widget>[
            Text(context.tr("media_library.sorting_and_classification_form.sorting_method")),
            SizedBox(
              width: 150,
              child: FSelect<SortingMethod<T>>.rich(
                contentGroupId: selectGroupId,
                control: FSelectControl<SortingMethod<T>>.managed(
                  initial: controller.sortingMethod,
                  onChange: (SortingMethod<T>? method){
                    if(method != null){
                      controller.setSortingMethod(method);
                    }
                  },
                ),
                format: (SortingMethod<T> value){
                  return context.tr(_sortingMethodTrKey[value]!);
                },
                children: <FSelectItemMixin>[
                  FSelectItemMixin.item(
                    title: Text(context.tr(_sortingMethodTrKey[SortingMethod<T>.random()]!)),
                    value: SortingMethod<T>.random(),
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_sortingMethodTrKey[SortingMethod<T>.none()]!)),
                    value: SortingMethod<T>.none(),
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_sortingMethodTrKey[SortingMethod<T>.cTime()]!)),
                    value: SortingMethod<T>.cTime(),
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_sortingMethodTrKey[SortingMethod<T>.mTime()]!)),
                    value: SortingMethod<T>.mTime(),
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_sortingMethodTrKey[SortingMethod<T>.size()]!)),
                    value: SortingMethod<T>.size(),
                  ),
                ],
              ),
            ),
          ],
        );

        final Widget classificationStandardForm = Row(
          spacing: 8,
          children: <Widget>[
            Text(context.tr("media_library.sorting_and_classification_form.classify_left")),
            SizedBox(
              width: 150,
              child: FSelect<ClassificationStandard>.rich(
                contentGroupId: selectGroupId,
                control: .managed(
                  initial: controller.classificationStandard,
                  onChange: (ClassificationStandard? classificationStandard){
                    if(classificationStandard != null){
                      controller.setClassificationStandard(classificationStandard);
                    }
                  },
                ),
                format: (ClassificationStandard value){
                  return context.tr(_classificationStandardTrKey[value]!);
                },
                children: <FSelectItemMixin>[
                  FSelectItemMixin.item(
                    title: Text(context.tr(_classificationStandardTrKey[ClassificationStandard.year]!)),
                    value: ClassificationStandard.year,
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_classificationStandardTrKey[ClassificationStandard.month]!)),
                    value: ClassificationStandard.month,
                  ),
                  FSelectItemMixin.item(
                    title: Text(context.tr(_classificationStandardTrKey[ClassificationStandard.day]!)),
                    value: ClassificationStandard.day,
                  ),
                ],
              ),
            ),
            if(context.trExists("media_library.sorting_and_classification_form.classify_right"))
              Text(context.tr("media_library.sorting_and_classification_form.classify_right")),
          ],
        );

        return Column(
          spacing: 8,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: <Widget>[
            sortingMethodForm,
            FDivider(style: .delta(width: 2), axis: .vertical),

            if(controller.canClassify())
              classificationStandardForm,

            if(controller.canClassify())
              FDivider(style: .delta(width: 2), axis: .vertical),

            if(controller.sortingMethod == SortingMethod<T>.random())
              FButton(
                variant: FButtonVariant.outline,
                onPress: (){
                  controller.refresh();
                },
                child: Column(
                  spacing: 4,
                  children: <Widget>[
                    Icon(FLucideIcons.refreshCcw),
                    Text(context.tr("media_library.sorting_and_classification_form.reshuffle")),
                  ],
                ),
              ),

            if(controller.sortingMethod != SortingMethod<T>.random())
              Row(
                spacing: 8,
                children: <Widget>[
                  FButton(
                    variant: !controller.reverse ? FButtonVariant.primary : FButtonVariant.outline,
                    selected: !controller.reverse,
                    onPress: (){
                      controller.setReverse(false);
                    },
                    child: Column(
                      spacing: 4,
                      children: <Widget>[
                        Icon(FLucideIcons.sortAsc),
                        Text(context.tr("media_library.sorting_and_classification_form.ascending_order")),
                      ],
                    ),
                  ),
                  FButton(
                    variant: controller.reverse ? FButtonVariant.primary : FButtonVariant.outline,
                    selected: controller.reverse,
                    onPress: (){
                      controller.setReverse(true);
                    },
                    child: Column(
                      spacing: 4,
                      children: <Widget>[
                        Icon(FLucideIcons.sortDesc),
                        Text(context.tr("media_library.sorting_and_classification_form.descending_order")),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );

    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 20, top: 14, right: 20, bottom: 20),
      child: SizedBox(
        child: child,
      ),
    );
  }
}