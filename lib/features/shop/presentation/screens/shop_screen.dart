import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_text.dart';
import 'package:tiger_tap_quest/core/shared/widgets/custom_popup.dart';
import 'package:tiger_tap_quest/core/domain/bloc/stats_bloc.dart';
import 'package:tiger_tap_quest/features/shop/domain/bloc/shop_bloc.dart';
import 'package:tiger_tap_quest/core/data/models/shop_item.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
            ),
          ),

          SafeArea(
            child: BlocBuilder<ShopBloc, ShopState>(
              builder: (context, shopState) {
                if (shopState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return BlocBuilder<StatsBloc, StatsState>(
                  builder: (context, statsState) {
                    final coins = statsState.stats.coins;

                    return CustomScrollView(
                      slivers: [

                        SliverAppBar(
                          expandedHeight: 180,
                          pinned: true,
                          backgroundColor: Colors.black.withValues(alpha: 0.6),
                          leading: IconButton(
                            tooltip: 'Back',
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => context.pop(),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 40),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2A2A2A).withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('🪙', style: TextStyle(fontSize: 32)),
                                          SizedBox(width: 12),
                                          CustomText(
                                            coins.toString(),
                                            style: theme.textTheme.headlineMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    CustomText(
                                      'Jungle Shop',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SliverPadding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = shopState.items[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildShopItemCard(context, item, coins),
                                );
                              },
                              childCount: shopState.items.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItemCard(BuildContext context, ShopItem item, int userCoins) {
    final theme = Theme.of(context);
    final price = item.level == 0 ? item.price : item.nextLevelPrice;
    final canAfford = userCoins >= price;
    final isMaxLevel = item.isMaxLevel;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [

              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFF3A3A3A).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(item.emoji, style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      item.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      item.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Level ${item.level} / ${item.maxLevel}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: item.level / item.maxLevel,
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              ElevatedButton(
                onPressed: isMaxLevel
                    ? null
                    : () {
                        if (!canAfford) {

                          CustomPopup.show(
                            context,
                            title: 'Not Enough Coins',
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🪙', style: TextStyle(fontSize: 48)),
                                SizedBox(height: 12),
                                Text(
                                  'You need $price coins to purchase this upgrade.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'You have: $userCoins coins',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            confirmLabel: 'OK',
                          );
                        } else {
                          context.read<ShopBloc>().add(PurchaseItem(item));
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford && !isMaxLevel
                      ? theme.colorScheme.primary
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMaxLevel) ...[
                      Text('🪙', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 6),
                      Text(
                        price.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ] else
                      Text(
                        'MAX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
