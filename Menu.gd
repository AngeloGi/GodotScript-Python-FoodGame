extends Control

var gameScene
var skins = {}

var selected
var currentlySelectedSkin
var help = 2
var maxhelp = 2
var multyCanRot = false
var multy = 1
var multystep 
var canRot = false
var  multyleft = false
var foods


func _init():
	TranslationServer.set_locale(Settings.getLanguage())
	
	skins = {
	default = [preload("res://Art/PlaceHolderFood.png"),tr("FIST_DESC"),tr("FIST_BUFF")],
	sword = [preload("res://Art/Weapons/Sword.png"),"Slice through bad taste!","+5 Points per hit"],
	hammer = [preload("res://Art/Weapons/Hammer.png"),"Hammer time!","-5% Time descrease speed "],
	keyboard = [preload("res://Art/Weapons/Keyboard.png"),"Not only for typing!","+0.5% heart chance"]
}

func _ready():
	PlayerData.Load()
	Settings.Load()
	gameScene = load("res://Stage/Stage.tscn")
	$Main/HighScoreBG/HighScore.set_text(str(PlayerData.GetHighScore())) #set highscore in menu label
	selected = PlayerData.getCurrentWeaponID()
	setVisibility()
	AudioManager.InGameStop()
	refreshMenu() #refeesh menu
	$Help/Time/Timebar.max_value = 2
	$Help/Time/Time.modulate.b = 0
	$Help/Time/Timebar.modulate.b = 0

func _process(delta):
	helpValues()
	multy += 0.01666666
	multystep = stepify((multy),1)
	if multy > 11:
		multy = 0
		if foods:
			foods = false
		else:
			foods = true
	$Help/Mult/X/Multiplier.set_text("x" + str(multystep))
	if multyleft == true:
		$Help/Mult/X.set_rotation(-0.18 )
	else:
		$Help/Mult/X.set_rotation(0.18 )
	
	
func refreshMenu():            #refreshes menu
	if Settings.getMusic():    # if music is on change label
		$Options/AudioOnOff/OnOff.set_text(tr("AUDIO_SETTING_ON"))
	else:                      #if music is on
		$Options/AudioOnOff/OnOff.set_text(tr("AUDIO_SETTING_OFF"))
	AudioManager.mainMenuPlay() # play main menu music from Audio manager
	
	# Localization {
	
	$Main/Buttons/Start/Play.set_text(tr("PLAY"))
	$Main/Buttons/Shop/Shop.set_text(tr("SHOP"))
	$Main/Buttons/Options/Options.set_text(tr("SETTINGS"))
	$Main/Buttons/Leaderboard/Leaderboard.set_text(tr("LEADERBOARD"))
	$Main/Buttons/Help/Help.set_text(tr("HELP"))
	$Options/Back_Options/Back.set_text(tr("BACK_BUTTON"))
	$Help/BackInst/Back.set_text(tr("BACK_BUTTON"))
	$Help/Background/HowTo.set_text(tr("HOW_TO_PLAY"))
	$Help/Background/Goal.set_text(tr("HELP_TEXT"))
	$Shop/BackShop/Back.set_text(tr("BACK_BUTTON"))
	$Shop/BuySugar1/Amount.set_text("x " + tr("SUGAR"))
	$Help/Fotos/EAT.set_text(tr("EAT"))
	$Help/Fotos/HIT.set_text(tr("HIT"))
	# }


func setVisibility():                             # Runs to make skins dark when unavailable
	if !PlayerData.IsSkinAvailable("default"):
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.r = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.g = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.b = 0.3
	else:
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.r = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.g = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_1.modulate.b = 1
		
	if !PlayerData.IsSkinAvailable("sword"):
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.r = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.g = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.b = 0.3
	else:
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.r = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.g = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_2.modulate.b = 1

	if !PlayerData.IsSkinAvailable("hammer"):
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.r = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.g = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.b = 0.3
	else:
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.r = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.g = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_3.modulate.b = 1

	if !PlayerData.IsSkinAvailable("keyboard"):
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.r = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.g = 0.3
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.b = 0.3
	else:
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.r = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.g = 1
		$Options/WeaponGridContainer/WeaponGrid/Skin_Buttons_4.modulate.b = 1

### On Buttons pressed ###

func _on_BuyMoney_pressed():
	pass # Replace with function body.

func _on_AudioOnOff_pressed():
	if Settings.getMusic() == true:
		Settings.setMusic(false) 
	else:
		Settings.setMusic(true)
	refreshMenu()
	
func _on_Options_pressed():
	$Options.visible = true
	$Main.visible = false
	AudioManager.clickPlay()

func _on_Shop_pressed():
	$Shop.visible = true
	$Main.visible = false
	AudioManager.clickPlay()

func _on_About_pressed():
	$About.visible = true
	$Main.visible = false
	$Currency.visible = false
	AudioManager.clickPlay()

func _on_Back_Options_pressed():
	$Main.visible = true
	$Options.visible = false
	AudioManager.clickPlay()

func _on_BackShop_pressed():
	$Main.visible = true
	$Shop.visible = false
	AudioManager.clickPlay()

func _on_Back_About_pressed():
	$Main.visible = true
	$Currency.visible = true
	$About.visible = false
	AudioManager.clickPlay()
	

func _on_BackInst_pressed():
	$Main.visible = true
	$Currency.visible = true
	$Help.visible = false
	AudioManager.clickPlay()
	

func _on_Help_pressed():
	$Help.visible = true
	$Main.visible = false
	$Currency.visible = false
	AudioManager.clickPlay()

func _on_Start_pressed():
	get_tree().change_scene_to(gameScene)
	AudioManager.clickPlay()

func infoOnPress(skinName):
	$Options/Selected.visible = true
	$Options/WoodenBG/Description.visible = true
	$Options/WoodenBG/Buff.visible = true
	$Options/WoodenBG/Description.set_text(skins[skinName][1])
	$Options/Selected.set_texture(skins[skinName][0])
	$Options/WoodenBG/Buff.set_text(skins[skinName][2])
	currentlySelectedSkin = skinName                     # Remember which skin the player just picked
	if PlayerData.getCurrentWeaponID() == skinName:      # Check if skin selected is the one equipped
		$Options/WoodenBG/Equip_Info.visible = true
		$Options/WoodenBG/Equip_Info/EquipLabel.set_text(tr("SKIN_EQUIPPED"))
		$Options/WoodenBG/Equip_Info/EquipLabel.add_color_override("font_color",Color(1,0.5,0,1))
		$Options/Selected/Locked.visible = false
		$Options/WoodenBG/BuyCurrency.visible = false
		$Options/WoodenBG/BuyMoney.visible = false
		return                                          # exit function
	if PlayerData.IsSkinAvailable(skinName):           
		$Options/WoodenBG/Equip_Info.visible = true
		$Options/WoodenBG/Equip_Info/EquipLabel.set_text(tr("SKIN_AVAILABLE"))
		$Options/WoodenBG/Equip_Info/EquipLabel.add_color_override("font_color",Color(1,1,0,1))
		$Options/Selected/Locked.visible = false
		$Options/WoodenBG/BuyCurrency.visible = false
		$Options/WoodenBG/BuyMoney.visible = false
	else:
		$Options/Selected/Locked.visible = true
		$Options/Selected/Locked.set_text(tr("SKIN_LOCKED"))
		$Options/WoodenBG/Equip_Info.visible = false
		$Options/WoodenBG/BuyCurrency.visible = true
		$Options/WoodenBG/BuyMoney.visible = true

func _on_Equip_Info_pressed():
	PlayerData.setCurrentWeaponID(currentlySelectedSkin)     # Equip the weapon 
	infoOnPress(currentlySelectedSkin)                       # Graphical update
	
func _on_Skin_1_pressed():
	infoOnPress("default")

func _on_Skin_2_pressed():
	infoOnPress("sword")

func _on_Skin_3_pressed():
	infoOnPress("hammer")

func _on_Skin_4_pressed():
	infoOnPress("keyboard")

func _on_Skin_5_pressed():
	pass # Replace with function body.

func _on_Skin_6_pressed():
	pass # Replace with function body.

func _on_Skin_7_pressed():
	pass # Replace with function body.

func _on_Skin_8_pressed():
	pass # Replace with function body.

func _on_Skin_9_pressed():
	pass # Replace with function body.

func _on_Skin_10_pressed():
	pass # Replace with function body.

func _on_Skin_11_pressed():
	pass # Replace with function body.

func _on_Skin_12_pressed():
	pass # Replace with function body.

func _on_BuyCurrency_pressed():
	PlayerData.UnlockSkin(currentlySelectedSkin)        # placeholder code that unlocks skin on press
	infoOnPress(currentlySelectedSkin)                  # Graphical update
	setVisibility()                                     #

func _notification(what):                   # Code to handle android back button
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		if $Options.visible:
			_on_Back_Options_pressed()
		elif $Shop.visible:
			_on_BackShop_pressed()
		elif $Help:
			_on_BackInst_pressed()
		elif $About.visible:
			_on_Back_About_pressed()
		else:
			get_tree().quit()

func _on_Language_pressed():
	if Settings.getLanguage() == "en":
		TranslationServer.set_locale("el")
		Settings.setLanguage("el")
		$Options/Language/Language.texture = load("res://Art/Greece.png")
	elif Settings.getLanguage() == "el":
		TranslationServer.set_locale("de")
		Settings.setLanguage("de")
		$Options/Language/Language.texture = load("res://Art/Germany.png")
	else:
		Settings.setLanguage("en")
		TranslationServer.set_locale("en")
		$Options/Language/Language.texture = load("res://Art/English.png")
	refreshMenu()
	
func helpValues():   #for tutorial values
	help -= 0.01
	var helpstep = stepify((help),0.1)
	
	$Help/Time/Time.set_text(str(helpstep))
	$Help/Time/Timebar.value = helpstep
	$Help/Time/Time.modulate.g = (helpstep/2)  # Change bar color depending on time left
	$Help/Time/Time.modulate.r = (1 - helpstep/2)
	$Help/Time/Timebar.modulate.g = $Help/Time/Time.modulate.g          # Match bar color
	$Help/Time/Timebar.modulate.r = $Help/Time/Time.modulate.r   
	if help <= 0:
		help = 2
	$Help/Mult/X/Multiplier.modulate.g = 0.1 - multy * 0.1
	$Help/Mult/X/Multiplier.modulate.b = 0.9 - multy * 0.1
		
	if multy < 0.8 or multy > 10:                         #When multiplier is more than 5 then the Multiplier letters start rotating
		canRot = false
		$Help/Mult/X.visible = false
	else:
		$Help/Mult/X.visible = true
		if canRot == false:
			$Help/Mult/Rot.start()
			canRot = true
	if foods:
		$Help/Fotos/Junk1.texture = load("res://Art/Junk/Burger.png")
		$Help/Fotos/Junk2.texture = load("res://Art/Junk/Cake.png")
		$Help/Fotos/Health1.texture = load("res://Art/Healhty/Cabbage.png")
		$Help/Fotos/Health2.texture = load("res://Art/Healhty/Zucchini.png")
	else:
		$Help/Fotos/Junk1.texture = load("res://Art/Junk/Fries.png")
		$Help/Fotos/Junk2.texture = load("res://Art/Junk/Noodles.png")
		$Help/Fotos/Health1.texture = load("res://Art/Healhty/Onion.png")
		$Help/Fotos/Health2.texture = load("res://Art/Healhty/Lettuce.png")

func _on_Rot_timeout():
	multyleft = not multyleft
