import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.responsive(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile,
      desktop: desktop ?? tablet ?? mobile,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? ResponsiveHelper.getMaxContentWidth(context),
      ),
      padding: padding ?? ResponsiveHelper.responsivePadding(context),
      margin: margin ?? ResponsiveHelper.responsiveMargin(context),
      child: child,
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? forceColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.forceColumns,
  });

  @override
  Widget build(BuildContext context) {
    final columns = forceColumns ?? ResponsiveHelper.getGridColumns(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.9,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = ResponsiveHelper.getCardWidth(context);

    return Container(
      width: cardWidth == double.infinity ? null : cardWidth,
      child: Card(
        elevation: elevation ?? 2.0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding ?? ResponsiveHelper.responsivePadding(context),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final double mobileSize;
  final double? tabletSize;
  final double? desktopSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    this.mobileSize = 14,
    this.tabletSize,
    this.desktopSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ResponsiveHelper.responsiveTextStyle(
        context,
        mobileSize: mobileSize,
        tabletSize: tabletSize,
        desktopSize: desktopSize,
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isExpanded;
  final Widget? icon;
  final ButtonStyle? style;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isExpanded = true,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = ResponsiveHelper.getButtonSize(context);

    Widget button;
    if (icon != null) {
      button = ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: Text(text),
        style: style,
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(text),
      );
    }

    if (isExpanded && ResponsiveHelper.isMobile(context)) {
      return SizedBox(
        width: double.infinity,
        height: buttonSize.height,
        child: button,
      );
    } else {
      return SizedBox(
        width: buttonSize.width == double.infinity ? null : buttonSize.width,
        height: buttonSize.height,
        child: button,
      );
    }
  }
}

class ResponsiveSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const ResponsiveSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }
}

class AdaptiveDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const AdaptiveDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    } else {
      return Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text(content),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
            ],
          ),
        ),
      );
    }
  }
}
