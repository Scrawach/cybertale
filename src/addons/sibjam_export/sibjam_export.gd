@tool
extends EditorPlugin

var custom_export: EditorExportPlugin

func _enter_tree() -> void:
	custom_export = SibJamExport.new()
	add_export_plugin(custom_export)

func _exit_tree() -> void:
	remove_export_plugin(custom_export)

class SibJamExport extends EditorExportPlugin:
	var exported_files: Array[String] = [
		"res://addons/sibjam_export/template/logo-background.png",
		"res://addons/sibjam_export/template/logo-gamepad.png",
		"res://addons/sibjam_export/template/logo-text.png",
	]
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
		if not features.has("web"):
			return
		
		var target_directory: String = path.get_base_dir()
		for file_path in exported_files:
			var filename = file_path.get_file()
			DirAccess.copy_absolute(file_path, target_directory + "/" + filename)
			print("File %s exported!" % filename)

	func _supports_platform(platform):
		return platform is EditorExportPlatformWeb

	func _get_name():
		return "SibJam Export Plugin"
