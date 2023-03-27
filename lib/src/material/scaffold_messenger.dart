import 'package:flutter/material.dart';

class SnackBarRepository {
  const SnackBarRepository(this.context);

  final BuildContext context;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
      String message,
      {String? closeTooltip}) {
    context._scaffoldMessenger.clearSnackBars();
    return context._scaffoldMessenger.showSnackBar(_snackBarBuilder(
      message,
      context.theme.colorScheme.background,
      Icons.info_outline,
      closeTooltip,
    ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning(
      String message,
      {String? closeTooltip}) {
    context._scaffoldMessenger.clearSnackBars();
    return context._scaffoldMessenger.showSnackBar(_snackBarBuilder(
      message,
      Colors.orange.shade800,
      Icons.warning_amber_outlined,
      closeTooltip,
    ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
      String message,
      {String? closeTooltip}) {
    context._scaffoldMessenger.clearSnackBars();
    return context._scaffoldMessenger.showSnackBar(_snackBarBuilder(
      message,
      context.theme.colorScheme.error,
      Icons.error_outline_outlined,
      closeTooltip,
    ));
  }

  SnackBar _snackBarBuilder(
    String message,
    Color backgroundColor,
    IconData? icon,
    String? closeTooltip,
  ) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
    );
  }
}

class MaterialBannerRepository {
  const MaterialBannerRepository(this.context);

  final BuildContext context;

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
      showInfo(String message, {String? closeTooltip}) {
    context.clearMaterialBanners();
    return context._scaffoldMessenger.showMaterialBanner(_materialBannerBuilder(
      message,
      context.theme.colorScheme.background,
      Icons.info_outline,
      closeTooltip,
    ));
  }

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
      showWarning(String message, {String? closeTooltip}) {
    context.clearMaterialBanners();
    return context._scaffoldMessenger.showMaterialBanner(_materialBannerBuilder(
      message,
      Colors.orange.shade800,
      Icons.warning_amber_outlined,
      closeTooltip,
    ));
  }

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
      showError(String message, {String? closeTooltip}) {
    final theme = Theme.of(context);
    context.clearMaterialBanners();
    return context._scaffoldMessenger.showMaterialBanner(_materialBannerBuilder(
      message,
      theme.colorScheme.error,
      Icons.error_outline_outlined,
      closeTooltip,
    ));
  }

  MaterialBanner _materialBannerBuilder(
    String message,
    Color backgroundColor,
    IconData? icon,
    String? closeTooltip,
  ) {
    final theme = Theme.of(context);
    return MaterialBanner(
      elevation: 6,
      contentTextStyle: theme.textTheme.bodyMedium,
      backgroundColor: backgroundColor,
      leading: Icon(
        icon,
        color: theme.colorScheme.onPrimary,
        size: 32,
      ),
      content: Text(message),
      actions: [
        IconButton(
          tooltip: 'Close',
          icon: Icon(
            Icons.close,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            context._scaffoldMessenger.removeCurrentMaterialBanner();
          },
        ),
      ],
    );
  }
}

extension ScaffoldMessengerOfContext on BuildContext {
  SnackBarRepository get snackbar => SnackBarRepository(this);

  MaterialBannerRepository get banner => MaterialBannerRepository(this);

  ScaffoldMessengerState get _scaffoldMessenger => ScaffoldMessenger.of(this);

  void clearSnackBars() => _scaffoldMessenger.clearSnackBars();
  void hideCurrentSnackBar() => _scaffoldMessenger.hideCurrentSnackBar();
  void removeCurrentSnackBar() => _scaffoldMessenger.removeCurrentSnackBar();

  void clearMaterialBanners() => _scaffoldMessenger.clearMaterialBanners();
  void hideCurrentMaterialBanner() =>
      _scaffoldMessenger.hideCurrentMaterialBanner();
  void removeCurrentMaterialBanner() =>
      _scaffoldMessenger.removeCurrentMaterialBanner();
}

extension ThemeOfContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}
