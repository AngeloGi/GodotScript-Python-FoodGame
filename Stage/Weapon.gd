extends Area2D

var currentWeaponID = "default"
var allowHit = false
var allowReturn = false
var speedMultiplier
var animationType
var currentWeapon

var weaponCatalog = {                                # All weapons go here, can get additional attributes
 
"default" : ["res://Art/Weapons/Sword.png","sharp"],  # to be replaced with final assets / attributes
"sword" : ["res://Art/Weapons/Sword.png","sharp"],
"hammer" : ["res://Art/Weapons/Hammer.png","bludge"],
"keyboard" : ["res://Art/Weapons/Keyboard.png","bludge"],
"Weap5" : "res://Art/Weapons/weap5.png",
"Weap6" : "res://Art/Weapons/weap6.png",
"Weap7" : "res://Art/Weapons/weap7.png",
"Weap8" : "res://Art/Weapons/weap8.png",
"Weap9" : "res://Art/Weapons/weap9.png",
"Weap10" : "res://Art/Weapons/weap10.png",
"Weap11" : "res://Art/Weapons/weap11.png",
"Weap12" : "res://Art/Weapons/weap12.png",
}

func _init():
	PlayerData.Load()
	position.x = 650
	position.y = 1080

func _process(delta):
	speedMultiplier = get_parent().speedMultiplierForFood

func _ready():
	speedMultiplier = get_parent().speedMultiplierForFood
	currentWeaponID = PlayerData.getCurrentWeaponID() # Get ID string from player data
	currentWeapon = weaponCatalog[currentWeaponID]   # Fetch weapon array with asset path and attributes
	$CollisionBox/WeaponSprite.texture = load(currentWeapon[0])  # Use array first element for path
	animationType = currentWeapon[1]                            # Use array second elemnent for weap type

func playWeaponAnimation():               # Called by stage, checks what kind of weapon is equipped and 
	match animationType:                  # plays matching animation
		"sharp":
			$Animation.playback_speed = 8 * speedMultiplier
			$Animation.play("Slash")      # Plays hit animations
		"bludge":
			$Animation.playback_speed = 8 * speedMultiplier
			$Animation.play("Bludgeon")  #TO-DO Make animation
		_:                                # default (no match)
			pass

func _on_Animation_animation_finished(anim_name):     # Called when all animations end
	match anim_name:                                  # checks which animation just ended
		"Slash":
			$Animation.playback_speed = 5 * speedMultiplier
			$Animation.play("SlashReturn") # Plays return animations
		"Bludgeon":
			$Animation.playback_speed = 5 * speedMultiplier
			$Animation.play("BludgeonReturn") # Plays return animations
		_:
			pass