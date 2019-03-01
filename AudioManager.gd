extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func mainMenuPlay():
	if Settings.getMusic():
		$MainMenu.play()
	else:
		$MainMenu.stop()

func mainMenuStop():              #STOPS main menu music
	if Settings.getMusic():
		$MainMenu.stop()
		
func InGamePlay():             
	if Settings.getMusic():
		$InGame.play()

func InGameStop():              #STOPS ingame music
	if Settings.getMusic():
		$InGame.stop()

func clickPlay():
	if Settings.getMusic():
		$Click.play()


func eatPlay():
	if Settings.getMusic():
		$Eat.play()

func hitPlay():
	if Settings.getMusic():
		$Hit.play()