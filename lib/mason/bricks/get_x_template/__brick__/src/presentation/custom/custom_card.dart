import 'dart:ui';
import 'package:flutter/material.dart';

/// **FloatSurfaceCard (FSC)**
///
/// A lightweight, theme-aware surface that appears softly lifted from any canvas.
///
/// **Purpose:**
/// - Provide a consistent "floating" container for balances, action trays, rows, and info panels
/// - Look elevated on any background (light, dark, tinted, or imagery)
/// - Preserve legibility and accessibility without manual tweaking per screen
/// - Scale from tiny list rows to hero cards
///
/// **Core Principles:**
/// - Separation without heaviness – elevation via subtle dual-shadow + hairline stroke
/// - Theme-aware – colors, shadows, and strokes adapt to canvas/background luminance
/// - Breathable layout – generous radius and internal padding
/// - Stateful – clear hover/press/focus/disabled affordances
/// - Performance-minded – minimal layers, predictable tokens
///
/// **Example:**
/// ```dart
/// FloatSurfaceCard(
///   size: FSCSize.standard,
///   elevation: FSCElevation.resting,
///   onTap: () => print('Tapped'),
///   leading: Icon(Icons.wallet),
///   body: Text('Main Wallet'),
///   trailing: Icon(Icons.chevron_right),
/// )
/// ```
///
// ────────────────────────────────────────────────

/// Elevation scale for FloatSurfaceCard
enum FSCElevation {
  /// No shadow, stroke only (for dense lists or inside sheets)
  quiet,

  /// Default elevation for standard cards
  resting,

  /// Stronger depth for hero/feature cards
  prominent,

  /// Reduced elevation and slightly scaled (98%)
  pressed,

  /// When pinned (e.g., at top on scroll), converts to stroke+tiny shadow
  sticky,
}

/// Size presets for FloatSurfaceCard
enum FSCSize {
  /// XL radius, 20-24 padding, Prominent elevation (large feature cards)
  hero,

  /// L radius, 16-20 padding, Resting elevation (standard cards)
  standard,

  /// M radius, 12-16 padding, Quiet/Resting elevation (list rows)
  row,
}

/// Background effect options for FloatSurfaceCard
enum FSCBackgroundEffect {
  /// No effect, plain decoration
  none,

  /// Backdrop blur (8px sigma)
  blur,

  /// Backdrop blur (12px sigma) + semi-transparent surface
  frosted,
}

/// **FloatSurfaceCard**
///
/// Main widget for creating floating surface cards with adaptive theming.
class FloatSurfaceCard extends StatefulWidget {
  /// Optional header widget (title, subtitle, meta)
  final Widget? header;

  /// Required body content
  final Widget body;

  /// Optional footer widget (supporting text or secondary actions)
  final Widget? footer;

  /// Optional leading widget (icon, avatar)
  final Widget? leading;

  /// Optional trailing widget (action, chevron, badge)
  final Widget? trailing;

  /// Size preset (hero, standard, row)
  final FSCSize size;

  /// Elevation mode (quiet, resting, prominent, pressed, sticky)
  final FSCElevation elevation;

  /// Tap callback - makes card interactive
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Override canvas color for background-aware adaptation
  final Color? canvasColor;

  /// Override surface color
  final Color? surfaceColor;

  /// Background effect (none, blur, frosted)
  final FSCBackgroundEffect backgroundEffect;

  /// Card width
  final double? width;

  /// Card height
  final double? height;

  /// Override preset padding
  final EdgeInsets? padding;

  /// External margin
  final EdgeInsets? margin;

  /// Disabled state
  final bool disabled;

  const FloatSurfaceCard({
    super.key,
    this.header,
    required this.body,
    this.footer,
    this.leading,
    this.trailing,
    this.size = FSCSize.standard,
    this.elevation = FSCElevation.resting,
    this.onTap,
    this.onLongPress,
    this.canvasColor,
    this.surfaceColor,
    this.backgroundEffect = FSCBackgroundEffect.none,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.disabled = false,
  });

  @override
  State<FloatSurfaceCard> createState() => _FloatSurfaceCardState();
}

class _FloatSurfaceCardState extends State<FloatSurfaceCard> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _FSCTheme(
      context: context,
      size: widget.size,
      elevation: widget.disabled ? FSCElevation.quiet : widget.elevation,
      canvasColor: widget.canvasColor,
      surfaceColorOverride: widget.surfaceColor,
      isHovered: _isHovered,
      isPressed: _isPressed,
    );

    final isInteractive = widget.onTap != null || widget.onLongPress != null;
    final effectiveElevation = _isPressed && isInteractive
        ? FSCElevation.pressed
        : (_isHovered && isInteractive ? theme._elevatedElevation : widget.elevation);

    Widget cardContent = AnimatedContainer(
      duration: _isPressed
          ? const Duration(milliseconds: 120)
          : const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding ?? theme.padding,
      transform: _isPressed && isInteractive
          ? Matrix4.diagonal3Values(0.98, 0.98, 1.0)
          : Matrix4.identity(),
      decoration: BoxDecoration(
        color: widget.disabled
            ? theme.surfaceColor.withValues(alpha: 0.8)
            : theme.surfaceColor,
        borderRadius: BorderRadius.circular(theme.radius),
        border: Border.all(
          color: theme.strokeColor,
          width: 1,
        ),
        boxShadow: widget.disabled ? null : theme.getShadows(effectiveElevation),
      ),
      child: _buildSlotLayout(theme),
    );

    // Add inner highlight for dark mode
    if (theme.isDarkMode &&
        effectiveElevation != FSCElevation.quiet &&
        effectiveElevation != FSCElevation.pressed) {
      cardContent = Stack(
        children: [
          cardContent,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: effectiveElevation == FSCElevation.prominent ? 0.02 : 0.015,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(theme.radius),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Add background effect wrapper
    if (widget.backgroundEffect != FSCBackgroundEffect.none) {
      cardContent = _buildBackgroundEffect(cardContent);
    }

    // Add focus ring
    if (_isFocused && isInteractive) {
      cardContent = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radius + 2),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: cardContent,
      );
    }

    // Make interactive if callbacks provided
    if (isInteractive && !widget.disabled) {
      cardContent = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: Focus(
            focusNode: _focusNode,
            child: Semantics(
              button: true,
              enabled: !widget.disabled,
              child: cardContent,
            ),
          ),
        ),
      );
    }

    return cardContent;
  }

  Widget _buildSlotLayout(_FSCTheme theme) {
    final hasHeader = widget.header != null || widget.leading != null || widget.trailing != null;
    final hasFooter = widget.footer != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        if (hasHeader) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.leading != null) ...[
                SizedBox(
                  width: theme.leadingTrailingSize,
                  child: widget.leading!,
                ),
                const SizedBox(width: 12),
              ],
              if (widget.header != null)
                Expanded(child: widget.header!),
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                SizedBox(
                  width: theme.leadingTrailingSize,
                  child: widget.trailing!,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Body
        widget.body,

        // Footer
        if (hasFooter) ...[
          SizedBox(height: theme.size == FSCSize.hero ? 12 : 8),
          widget.footer!,
        ],
      ],
    );
  }

  Widget _buildBackgroundEffect(Widget child) {
    final sigma = widget.backgroundEffect == FSCBackgroundEffect.frosted ? 12.0 : 8.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(_FSCTheme(
        context: context,
        size: widget.size,
        elevation: widget.elevation,
      ).radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: widget.backgroundEffect == FSCBackgroundEffect.frosted
            ? Opacity(opacity: 0.85, child: child)
            : child,
      ),
    );
  }
}

/// **_FSCTheme**
///
/// Internal helper class for calculating theme-aware tokens
class _FSCTheme {
  final BuildContext context;
  final FSCSize size;
  final FSCElevation elevation;
  final Color? canvasColor;
  final Color? surfaceColorOverride;
  final bool isHovered;
  final bool isPressed;

  late final ColorScheme colorScheme;
  late final bool isDarkMode;
  late final double radius;
  late final EdgeInsets padding;
  late final double leadingTrailingSize;
  late final Color surfaceColor;
  late final Color strokeColor;

  _FSCTheme({
    required this.context,
    required this.size,
    required this.elevation,
    this.canvasColor,
    this.surfaceColorOverride,
    this.isHovered = false,
    this.isPressed = false,
  }) {
    colorScheme = Theme.of(context).colorScheme;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Size presets
    switch (size) {
      case FSCSize.hero:
        radius = 24.0;
        padding = const EdgeInsets.all(20.0);
        leadingTrailingSize = 56.0;
        break;
      case FSCSize.standard:
        radius = 16.0;
        padding = const EdgeInsets.all(16.0);
        leadingTrailingSize = 36.0;
        break;
      case FSCSize.row:
        radius = 12.0;
        padding = const EdgeInsets.all(12.0);
        leadingTrailingSize = 28.0;
        break;
    }

    // Surface color
    if (surfaceColorOverride != null) {
      surfaceColor = surfaceColorOverride!;
    } else {
      final baseSurface = colorScheme.surface;
      final tintAmount = isDarkMode ? 0.03 : 0.02;
      surfaceColor = Color.lerp(baseSurface, colorScheme.primary, tintAmount)!;

      // Add hover tint if hovered
      if (isHovered) {
        surfaceColor = Color.lerp(surfaceColor, colorScheme.primary, 0.04)!;
      }
    }

    // Stroke color (adaptive)
    if (canvasColor != null) {
      final luminance = canvasColor!.computeLuminance();
      strokeColor = luminance > 0.5
          ? Colors.black.withValues(alpha: 0.08)
          : Colors.white.withValues(alpha: 0.12);
    } else {
      strokeColor = isDarkMode
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.black.withValues(alpha: 0.08);
    }
  }

  /// Get elevated elevation (for hover state)
  FSCElevation get _elevatedElevation {
    switch (elevation) {
      case FSCElevation.quiet:
        return FSCElevation.resting;
      case FSCElevation.resting:
        return FSCElevation.prominent;
      case FSCElevation.prominent:
        return FSCElevation.prominent;
      case FSCElevation.pressed:
        return FSCElevation.pressed;
      case FSCElevation.sticky:
        return FSCElevation.resting;
    }
  }

  /// Get shadows for given elevation
  List<BoxShadow> getShadows(FSCElevation elevation) {
    // Shadow color (adaptive)
    final shadowColor = isDarkMode
        ? colorScheme.primary.withValues(alpha: 0.2)
        : Colors.grey.shade800;

    // Tint shadow toward canvas hue if provided
    final effectiveShadowColor = canvasColor != null
        ? Color.lerp(shadowColor, canvasColor!, 0.3)!
        : shadowColor;

    if (isDarkMode) {
      // Dark mode: minimal shadows
      switch (elevation) {
        case FSCElevation.quiet:
          return [];
        case FSCElevation.resting:
          return [
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.08),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ];
        case FSCElevation.prominent:
          return [
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.10),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ];
        case FSCElevation.pressed:
          return [];
        case FSCElevation.sticky:
          return [
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.06),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ];
      }
    } else {
      // Light mode: dual-shadow system
      switch (elevation) {
        case FSCElevation.quiet:
          return [];
        case FSCElevation.resting:
          return [
            // Ambient shadow
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
            // Key shadow
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.12),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          ];
        case FSCElevation.prominent:
          return [
            // Ambient shadow
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
            // Key shadow
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.16),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ];
        case FSCElevation.pressed:
          return [
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ];
        case FSCElevation.sticky:
          return [
            BoxShadow(
              color: effectiveShadowColor.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ];
      }
    }
  }
}
