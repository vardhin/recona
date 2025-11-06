import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../providers/theme_provider.dart';
import '../models/theme_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to Default',
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Primary Colors',
            [
              _buildColorTile(context, 'Primary', 'primary'),
              _buildColorTile(context, 'Primary Dark', 'primaryDark'),
              _buildColorTile(context, 'Primary Light', 'primaryLight'),
              _buildColorTile(context, 'Accent', 'accent'),
            ],
          ),
          _buildSection(
            context,
            'Background Colors',
            [
              _buildColorTile(context, 'Background', 'background'),
              _buildColorTile(context, 'Surface', 'surface'),
            ],
          ),
          _buildSection(
            context,
            'Text Colors',
            [
              _buildColorTile(context, 'Text Primary', 'textPrimary'),
              _buildColorTile(context, 'Text Secondary', 'textSecondary'),
              _buildColorTile(context, 'Text Hint', 'textHint'),
            ],
          ),
          _buildSection(
            context,
            'Icon Colors',
            [
              _buildColorTile(context, 'Icon Active', 'iconActive'),
              _buildColorTile(context, 'Icon Inactive', 'iconInactive'),
            ],
          ),
          _buildSection(
            context,
            'Status Colors',
            [
              _buildColorTile(context, 'Success', 'success'),
              _buildColorTile(context, 'Error', 'error'),
              _buildColorTile(context, 'Warning', 'warning'),
            ],
          ),
          _buildSection(
            context,
            'Other',
            [
              _buildColorTile(context, 'Divider', 'divider'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildColorTile(BuildContext context, String label, String colorKey) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final color = _getColorFromKey(themeProvider.themeSettings, colorKey);
        
        return ListTile(
          title: Text(label),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onTap: () => _showColorPicker(context, label, colorKey, color),
        );
      },
    );
  }

  Color _getColorFromKey(ThemeSettings settings, String key) {
    switch (key) {
      case 'primary': return settings.primary;
      case 'primaryDark': return settings.primaryDark;
      case 'primaryLight': return settings.primaryLight;
      case 'accent': return settings.accent;
      case 'background': return settings.background;
      case 'surface': return settings.surface;
      case 'textPrimary': return settings.textPrimary;
      case 'textSecondary': return settings.textSecondary;
      case 'textHint': return settings.textHint;
      case 'iconActive': return settings.iconActive;
      case 'iconInactive': return settings.iconInactive;
      case 'success': return settings.success;
      case 'error': return settings.error;
      case 'warning': return settings.warning;
      case 'divider': return settings.divider;
      default: return Colors.grey;
    }
  }

  Future<void> _showColorPicker(BuildContext context, String label, String colorKey, Color currentColor) async {
    Color selectedColor = currentColor;
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick $label Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color;
              },
              width: 40,
              height: 40,
              borderRadius: 8,
              spacing: 5,
              runSpacing: 5,
              wheelDiameter: 155,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.wheel: true,
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateColor(context, colorKey, selectedColor);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updateColor(BuildContext context, String colorKey, Color color) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentSettings = themeProvider.themeSettings;
    
    ThemeSettings newSettings;
    switch (colorKey) {
      case 'primary':
        newSettings = currentSettings.copyWith(primary: color);
        break;
      case 'primaryDark':
        newSettings = currentSettings.copyWith(primaryDark: color);
        break;
      case 'primaryLight':
        newSettings = currentSettings.copyWith(primaryLight: color);
        break;
      case 'accent':
        newSettings = currentSettings.copyWith(accent: color);
        break;
      case 'background':
        newSettings = currentSettings.copyWith(background: color);
        break;
      case 'surface':
        newSettings = currentSettings.copyWith(surface: color);
        break;
      case 'textPrimary':
        newSettings = currentSettings.copyWith(textPrimary: color);
        break;
      case 'textSecondary':
        newSettings = currentSettings.copyWith(textSecondary: color);
        break;
      case 'textHint':
        newSettings = currentSettings.copyWith(textHint: color);
        break;
      case 'iconActive':
        newSettings = currentSettings.copyWith(iconActive: color);
        break;
      case 'iconInactive':
        newSettings = currentSettings.copyWith(iconInactive: color);
        break;
      case 'success':
        newSettings = currentSettings.copyWith(success: color);
        break;
      case 'error':
        newSettings = currentSettings.copyWith(error: color);
        break;
      case 'warning':
        newSettings = currentSettings.copyWith(warning: color);
        break;
      case 'divider':
        newSettings = currentSettings.copyWith(divider: color);
        break;
      default:
        return;
    }
    
    themeProvider.updateThemeSettings(newSettings);
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Theme'),
          content: const Text('Are you sure you want to reset all colors to default?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).resetToDefault();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme reset to default')),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}