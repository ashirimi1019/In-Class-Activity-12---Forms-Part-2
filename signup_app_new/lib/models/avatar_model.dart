class AvatarModel {
  final String id;
  final String imagePath;
  final String name;
  bool isSelected;

  AvatarModel({
    required this.id,
    required this.imagePath,
    required this.name,
    this.isSelected = false,
  });

  // Create a list of default avatars
  static List<AvatarModel> defaultAvatars = [
    AvatarModel(
      id: '1',
      imagePath: 'lib/assets/images/avatar1.png',
      name: 'Adventurer',
    ),
    AvatarModel(
      id: '2',
      imagePath: 'lib/assets/images/avatar2.png',
      name: 'Explorer',
    ),
    AvatarModel(
      id: '3',
      imagePath: 'lib/assets/images/avatar3.png',
      name: 'Hero',
    ),
    AvatarModel(
      id: '4',
      imagePath: 'lib/assets/images/avatar4.png',
      name: 'Pioneer',
    ),
    AvatarModel(
      id: '5',
      imagePath: 'lib/assets/images/avatar5.png',
      name: 'Trailblazer',
    ),
  ];
}
