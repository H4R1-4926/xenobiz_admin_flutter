import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/providers/theme_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_typography.dart';
import '../responsive/responsive_breakpoints.dart';

class DataColumnDefinition {
  final String label;
  final double? width;
  final Alignment alignment;

  const DataColumnDefinition({
    required this.label,
    this.width,
    this.alignment = Alignment.centerLeft,
  });
}

class ResponsiveDataTable extends StatelessWidget {
  final List<DataColumnDefinition> columns;
  final List<List<Widget>> rows;
  final Widget? emptyWidget;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    if (rows.isEmpty) {
      return emptyWidget ?? const SizedBox.shrink();
    }

    Widget tableWidget = Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: columns.map((col) {
                final cellWidget = Text(
                  col.label.toUpperCase(),
                  style: AppTypography.labelBold(isDark).copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 11,
                  ),
                );

                if (col.width != null) {
                  return SizedBox(
                    width: col.width,
                    child: Align(alignment: col.alignment, child: cellWidget),
                  );
                }
                return Expanded(
                  child: Align(alignment: col.alignment, child: cellWidget),
                );
              }).toList(),
            ),
          ),
          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            itemBuilder: (context, rowIndex) {
              final cells = rows[rowIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: List.generate(cells.length, (colIndex) {
                    final colDef = columns[colIndex];
                    final cellWidget = cells[colIndex];

                    if (colDef.width != null) {
                      return SizedBox(
                        width: colDef.width,
                        child: Align(alignment: colDef.alignment, child: cellWidget),
                      );
                    }
                    return Expanded(
                      child: Align(alignment: colDef.alignment, child: cellWidget),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );

    final totalWidth = columns.fold<double>(0, (sum, col) => sum + (col.width ?? 160));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile || constraints.maxWidth < totalWidth) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: totalWidth < constraints.maxWidth ? constraints.maxWidth : totalWidth,
              child: tableWidget,
            ),
          );
        }
        return tableWidget;
      },
    );
  }
}
