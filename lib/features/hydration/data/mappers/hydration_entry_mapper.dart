import '../../../../core/database/app_database.dart';
import '../../domain/models/hydration_entry_model.dart';

extension HydrationEntryMapper on HydrationEntry {
  HydrationEntryModel toModel() {
    return HydrationEntryModel(id: id, amount: amount, createdAt: createdAt);
  }
}
