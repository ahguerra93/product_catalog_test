import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_colors.dart';
import '../../../../common/app_strings.dart';
import '../../../../common/app_dimens.dart';
import '../../../../shared/domain/enums/simulation_mode.dart';
import '../cubits/settings_cubit.dart';
import '../cubits/settings_state.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppDimens.drawerWidth,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(),
            const Divider(height: 1),
            const SizedBox(height: AppDimens.spacingMd),
            _SimulationModeTile(),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      color: context.colors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.settings, color: context.colors.textOnPrimary, size: 32),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            AppStrings.settings,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: context.colors.textOnPrimary),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            AppStrings.settingsSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: context.colors.textOnPrimary.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _SimulationModeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.simulateAppState,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: context.colors.textSecondary),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingXs),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.border),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  color: context.colors.surface,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<SimulationMode>(
                    value: state.simulationMode,
                    isExpanded: true,
                    icon: Icon(Icons.expand_more, color: context.colors.primary),
                    items: SimulationMode.values.map((mode) {
                      return DropdownMenuItem<SimulationMode>(
                        value: mode,
                        child: Row(
                          children: [
                            Icon(_iconForMode(mode), size: 18, color: _colorForMode(context, mode)),
                            const SizedBox(width: AppDimens.spacingSm),
                            Text(_labelForMode(mode), style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (mode) {
                      if (mode != null) {
                        context.read<SettingsCubit>().setSimulationMode(mode);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Text(
                _descriptionForMode(state.simulationMode),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: context.colors.textSecondary),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _iconForMode(SimulationMode mode) {
    return switch (mode) {
      SimulationMode.success => Icons.check_circle_outline,
      SimulationMode.empty => Icons.inbox_outlined,
      SimulationMode.error => Icons.error_outline,
    };
  }

  Color _colorForMode(BuildContext context, SimulationMode mode) {
    return switch (mode) {
      SimulationMode.success => context.colors.success,
      SimulationMode.empty => context.colors.warning,
      SimulationMode.error => context.colors.error,
    };
  }

  String _labelForMode(SimulationMode mode) {
    return switch (mode) {
      SimulationMode.success => AppStrings.simulationSuccess,
      SimulationMode.empty => AppStrings.simulationEmpty,
      SimulationMode.error => AppStrings.simulationError,
    };
  }

  String _descriptionForMode(SimulationMode mode) {
    return switch (mode) {
      SimulationMode.success => AppStrings.simulationSuccessDesc,
      SimulationMode.empty => AppStrings.simulationEmptyDesc,
      SimulationMode.error => AppStrings.simulationErrorDesc,
    };
  }
}
