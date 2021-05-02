final String tableCustomFolders = 'CustomFolders';

class CustomFolderFields {
  static final List<String> values = [id, filePath];
  static final String id = '_id';
  static final String filePath = 'filePath';
}

class CustomFolder {
  final int id;
  final String filePath;

  const CustomFolder({this.id, this.filePath});

  CustomFolder copy({
    int id,
    String filePath,
  }) =>
      CustomFolder(
        id: id ?? this.id,
        filePath: filePath ?? this.filePath,
      );

  static CustomFolder fromJson(Map<String, Object> json) => CustomFolder(
        id: json[CustomFolderFields.id] as int,
        filePath: json[CustomFolderFields.filePath] as String,
      );

  Map<String, Object> toJson() => {
        CustomFolderFields.id: id,
        CustomFolderFields.filePath: filePath,
      };
}
