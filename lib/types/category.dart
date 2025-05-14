import 'dart:collection';

import 'package:flutter/material.dart';

enum ApplianceCategory {
  electronics("Electronics"),
  fashion("Fashion"),
  garden("Garden"),
  kitchen("Kitchen"),
  living("Living");

  const ApplianceCategory(this.name);
  final String name;

  static final List<DropdownMenuEntry<ApplianceCategory>> entries = UnmodifiableListView(ApplianceCategory.values
      .map((category) => DropdownMenuEntry(
            label: category.name,
            value: category,
          ))
      .toList());
}