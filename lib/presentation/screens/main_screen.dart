import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/cat_controller.dart';
import '../../data/connectivity_service.dart';
import '../../di/service_locator.dart';

import '../widgets/cat_stack.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import 'liked_cats_screen.dart';
import '../themes/app_theme.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const MainScreen({super.key, required this.onToggleTheme});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showLoader = true;
  late final StreamSubscription<ConnectivityResult> _connSub;
  ConnectivityResult? _previousStatus;
  bool _isOnline = true;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = getIt<ConnectivityService>();
      service.checkConnectivity().then((status) {
        _previousStatus = status;
        if (status == ConnectivityResult.none) {
          _updateBannerOffline();
        }
      });
      _connSub = service.onConnectivityChanged.listen((status) {
        if (status != _previousStatus) {
          if (status == ConnectivityResult.none) {
            _updateBannerOffline();
          } else {
            _updateBannerOnline();
          }
          _previousStatus = status;
        }
      });
    });
  }

  void _updateBannerOffline() {
    setState(() {
      _isOnline = false;
      _showBanner = true;
    });
  }

  void _updateBannerOnline() {
    setState(() {
      _isOnline = true;
      _showBanner = true;
    });
    Provider.of<CatController>(context, listen: false).loadMore();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _showBanner = false);
    });
  }

  @override
  void dispose() {
    _connSub.cancel();
    super.dispose();
  }

  void _hideLoader() {
    if (!_showLoader) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _showLoader = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = cardWidth * 4 / 3;
    final frameHeight = cardHeight + 24;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<CatController>(
        builder: (_, controller, __) {
          final stackEmpty = controller.cats.isEmpty;
          final loading = _showLoader || stackEmpty;
          final alpha = (0.3 * 255).round();
          return Column(
            children: [
              Expanded(
                child: Center(
                  child:
                      stackEmpty
                          ? SizedBox(
                            width: cardWidth,
                            height: frameHeight,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: LoadingIndicator(),
                            ),
                          )
                          : CatStack(
                            cats: controller.cats,
                            isLoading: loading,
                            onSwipe: (liked) {
                              setState(() => _showLoader = true);
                              controller.handleSwipe(liked);
                            },
                            onTopLoaded: _hideLoader,
                          ),
                ),
              ),

              if (_showBanner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  color:
                      _isOnline
                          ? Colors.green.shade700.withAlpha(alpha)
                          : Colors.red.shade900.withAlpha(alpha),
                  child: Text(
                    _isOnline
                        ? 'Соединение восстановлено'
                        : 'Отсутствует соединение с интернетом',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),

              SizedBox(
                height: 40,
                child: AnimatedOpacity(
                  opacity: loading ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DislikeButton(
                      onPressed: () {
                        setState(() => _showLoader = true);
                        controller.handleSwipe(false);
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        stackEmpty
                            ? 'Загрузка…'
                            : controller.cats.first.breedName,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    LikeButton(
                      onPressed: () {
                        setState(() => _showLoader = true);
                        controller.handleSwipe(true);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext ctx) => AppBar(
    title: const Text('Cat Tinder'),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Consumer<CatController>(
          builder:
              (_, c, __) => GestureDetector(
                onTap:
                    () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => const LikedCatsScreen(),
                      ),
                    ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.badgeBg(ctx),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${c.likedCats.length}',
                        style: Theme.of(ctx).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.brightness_6),
        onPressed: widget.onToggleTheme,
      ),
    ],
  );
}
