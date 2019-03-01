extends Control

var languageCheck
var Menu = preload("res://Menu.tscn")

func _ready():
	Settings.Load()
	languageCheck = Settings.getHasPickedLanguage()
	if languageCheck:
		get_tree().change_scene_to(Menu)       # uncomment to remember language
	else:
		pass

func _on_English_pressed():
	TranslationServer.set_locale("en")
	Settings.setLanguage("en")
	get_tree().change_scene_to(Menu)


func _on_Greek_pressed():
	TranslationServer.set_locale("el")
	Settings.setLanguage("el")
	get_tree().change_scene_to(Menu)


func _on_German_pressed():
	TranslationServer.set_locale("de")
	Settings.setLanguage("de")
	get_tree().change_scene_to(Menu)
