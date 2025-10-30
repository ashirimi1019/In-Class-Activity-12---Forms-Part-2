import 'package:vibration/vibration.dart'; // Added import for Vibration
import 'package:flutter/material.dart';
import '../models/avatar_model.dart';

class AvatarSelector extends StatefulWidget {
  final Function(AvatarModel) onAvatarSelected;
  final double avatarSize;
  final double borderWidth;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;

  const AvatarSelector({
    super.key,
    required this.onAvatarSelected,
    this.avatarSize = 80.0,
    this.borderWidth = 3.0,
    this.selectedBorderColor = Colors.blue,
    this.unselectedBorderColor = Colors.grey,
  });

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late List<AvatarModel> _avatars;
  AvatarModel? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _avatars = List.from(AvatarModel.defaultAvatars);
    // Select first avatar by default
    if (_avatars.isNotEmpty) {
      _selectedAvatar = _avatars[0];
      _avatars[0].isSelected = true;
      widget.onAvatarSelected(_selectedAvatar!);
    }
  }

  void _handleAvatarTap(AvatarModel avatar) {
    setState(() {
      // Deselect previously selected avatar
      if (_selectedAvatar != null) {
        final prevIndex = _avatars.indexWhere(
          (a) => a.id == _selectedAvatar!.id,
        );
        if (prevIndex != -1) {
          _avatars[prevIndex].isSelected = false;
        }
      }

      // Select new avatar
      final index = _avatars.indexWhere((a) => a.id == avatar.id);
      if (index != -1) {
        _avatars[index].isSelected = true;
        _selectedAvatar = _avatars[index];
        widget.onAvatarSelected(_selectedAvatar!);
      }
    });

    // Haptic feedback
    _vibrate();
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
          child: Text(
            'Choose Your Avatar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: widget.avatarSize + 40, // Extra space for name and padding
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _avatars.length,
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              return _buildAvatarItem(avatar);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarItem(AvatarModel avatar) {
    final isSelected = avatar.isSelected;

    return GestureDetector(
      onTap: () => _handleAvatarTap(avatar),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            // Avatar image with border
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.avatarSize,
              height: widget.avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? widget.selectedBorderColor
                      : widget.unselectedBorderColor,
                  width: isSelected ? widget.borderWidth : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: widget.selectedBorderColor.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: Image.asset(
                  avatar.imagePath,
                  width: widget.avatarSize - 4,
                  height: widget.avatarSize - 4,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to a placeholder if image fails to load
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: widget.avatarSize * 0.6,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Avatar name
            Text(
              avatar.name,
              style: TextStyle(
                color: isSelected
                    ? widget.selectedBorderColor
                    : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
