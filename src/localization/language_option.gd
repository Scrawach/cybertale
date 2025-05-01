class_name LanguageOption
extends OptionButton

var locales: PackedStringArray

func _ready() -> void:
	initialize_locales()
	item_selected.connect(_on_item_selected)

func initialize_locales() -> void:
	const LANGUAGE_NAME_KEY: String = "LANGUAGE_NAME"
	locales = TranslationServer.get_loaded_locales()
	
	for locale_index in locales.size():
		var locale: String = locales[locale_index]
		var translation: Translation = TranslationServer.get_translation_object(locale)
		var language_name: String = translation.get_message(LANGUAGE_NAME_KEY)
		add_item(language_name)
	
	var start_locale: String = OS.get_locale_language()
	select(get_index_by_locale(start_locale))

func get_index_by_locale(locale: String) -> int:
	for index in locales.size():
		var find_locale: String = locales[index]
		if find_locale == locale:
			return index
	return 0

func get_locale_by_index(index: int) -> String:
	return locales[index]

func _on_item_selected(index: int) -> void:
	TranslationServer.set_locale(locales[index])
