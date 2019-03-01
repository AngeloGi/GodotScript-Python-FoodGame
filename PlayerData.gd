extends Node

#signal loadedFromGooglePlay

var SavePath = "user://PlayerData.sav" #make a save file omg

var Data = {
	HighScore = 0,
	currentWeaponID = "default",
	currency = 0,
	skins = {
		default = "unlocked",
		sword = "locked",
		hammer = "locked",
		keyboard = "locked"
	}
}

	
func _ready():
#	Google.connect("received_highscore",self,"received_highscore")
#	Google.connect("gameLoaded",self,"gameLoaded")
	Load()

func Save():
	var file = File.new()
	if file.open(SavePath, File.WRITE) !=0:
	#if file.open_encrypted_with_pass(SavePath, File.WRITE, OS.get_unique_id()) !=0:
		print ("Unable to save game")
		return
	file.store_line(JSON.print(Data))
	file.close()

func Load():
	var file = File.new()
	if not file.file_exists (SavePath):
		return
	if file.open(SavePath, File.READ)!= 0:
	#if file.open_encrypted_with_pass(SavePath, File.READ, OS.get_unique_id()) != 0:
		return
	var LoadedData = JSON.parse(file.get_line()).result
	file.close()
	for D in LoadedData.keys ():
		if Data.has(D) :
			Data[D] = LoadedData [D]

func SetHighScore (Score):
	if Score > Data.HighScore:
		Data.HighScore = Score
		#Google.sendHighScore(Score)
	Save()

func GetHighScore ():
	return Data.HighScore
#func loadFromGooglePlay():
#	Google.getHighScore()
#	Google.LoadFile("Currency.Sav")
#	Google.LoadFile("Skins.Sav")
#
## Highscores
#
#func SetHighScore (Score):
#	if Score > Data.HighScore:
#		Data.HighScore = Score
#		Google.sendHighScore(Score)
#	Save()
#
#func GetHighScore ():
#	return Data.HighScore
#
#Skins

func getCurrentWeaponID():
	return Data.currentWeaponID

func setCurrentWeaponID (skin):
	Data.currentWeaponID = skin
	Save()

func IsSkinAvailable(Skin):
	if not Data.skins.has(Skin):
		return false

	return Data.skins[Skin] == "unlocked"

func UnlockSkin(Skin):
	Data.skins[Skin] = "unlocked"
	Save()
#	Google.SaveFile("Skins.Sav",JSON.print(Data.Skins))
#
#
# Currency

func AddCurrency (Curr):
	Data.currency += Curr
#	SaveCur()

func SubCurrency (Curr):
	Data.currency -= Curr
#	SaveCur ()

#func SaveCur():
#	Google.SaveFile("Currency.Sav",str(Data.Currency))
#	Save ()
#
func GetCurrency ():
	return Data.currency

#func getClientID():
#	if OS.is_debug_build():
#		return "672026109199-i8pq6ocdjgsl37mpvm3do6e4id3iiims.apps.googleusercontent.com"
#	else:
#		return "672026109199-202tlgdln9j85t1i8q91lddndp3e58nv.apps.googleusercontent.com"
#
#func received_highscore(score):
#	Data.HighScore = score
#	Save()
#	emit_signal("loadedFromGooglePlay")
#
#func gameLoaded(file,data):
#	if file == "Currency.Sav":
#		Data.Currency = int(data)
#	if file == "Skins.Sav":
#		if data != "":
#			var LoadedSkins = JSON.parse(data).result
#			for D in LoadedSkins.keys ():
#				Data.Skins[D] = LoadedSkins[D]
#	Save()
#	emit_signal("loadedFromGooglePlay")