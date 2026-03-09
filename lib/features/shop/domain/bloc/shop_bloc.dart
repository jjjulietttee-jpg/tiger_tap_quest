import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiger_tap_quest/core/data/models/shop_item.dart';
import 'package:tiger_tap_quest/core/data/services/stats_service.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';


abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

class LoadShopItems extends ShopEvent {
  const LoadShopItems();
}

class PurchaseItem extends ShopEvent {
  final ShopItem item;

  const PurchaseItem(this.item);

  @override
  List<Object?> get props => [item];
}


class ShopState extends Equatable {
  final List<ShopItem> items;
  final bool isLoading;
  final String? error;

  const ShopState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  ShopState copyWith({
    List<ShopItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return ShopState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, error];
}


class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final StatsService _statsService;
  final StatsBloc _statsBloc;

  ShopBloc({
    required StatsService statsService,
    required StatsBloc statsBloc,
  })  : _statsService = statsService,
        _statsBloc = statsBloc,
        super(const ShopState()) {
    on<LoadShopItems>(_onLoadShopItems);
    on<PurchaseItem>(_onPurchaseItem);
  }

  Future<void> _onLoadShopItems(
    LoadShopItems event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final savedItems = await _statsService.loadShopItems();
      final items = ShopItems.all.map((template) {
        final saved = savedItems.firstWhere(
          (s) => s['id'] == template.id,
          orElse: () => <String, dynamic>{},
        );
        if (saved.isEmpty) return template;
        return ShopItem.fromJson(saved, template);
      }).toList();

      emit(state.copyWith(items: items, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to load shop items',
        isLoading: false,
      ));
    }
  }

  Future<void> _onPurchaseItem(
    PurchaseItem event,
    Emitter<ShopState> emit,
  ) async {
    final item = event.item;
    final currentCoins = _statsBloc.state.stats.coins;
    final price = item.level == 0 ? item.price : item.nextLevelPrice;


    if (item.isMaxLevel) {
      emit(state.copyWith(error: 'Item is already max level!'));
      return;
    }




    try {

      final updatedItem = item.copyWith(
        level: item.level + 1,
        isPurchased: true,
      );


      final updatedItems = state.items.map((i) {
        return i.id == item.id ? updatedItem : i;
      }).toList();


      await _statsService.saveShopItems(
        updatedItems.map((i) => i.toJson()).toList(),
      );


      final updatedStats = _statsBloc.state.stats.copyWith(
        coins: currentCoins - price,
      );
      await _statsService.saveStats(updatedStats);
      _statsBloc.add(UpdateStats(updatedStats));

      emit(state.copyWith(items: updatedItems, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to purchase item'));
    }
  }
}
