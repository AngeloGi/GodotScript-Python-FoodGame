extends Node

var SavePath = "user://Settings.sav"

var Data = {
	IsMusicOn = true,
	HasWatchedTutorial = false,
	currentLanguage = "en",
	hasPickedLanguage = false
}

func Save():
	var file = File.new()
	if file.open(SavePath, File.WRITE) !=0:
		print ("Unable to save settings")
		return
	file.store_line(JSON.print(Data))
	file.close()

func Load():
	var file = File.new()
	if not file.file_exists (SavePath):
		return
	if file.open(SavePath, File.READ) != 0:
		return
	var LoadedData = JSON.parse(file.get_line()).result
	file.close()
	for D in LoadedData.keys ():
		if Data.has(D) :
			Data[D] = LoadedData [D]

func setMusic (on):
	Data.IsMusicOn = on
	Save()

func getMusic ():
	return Data.IsMusicOn
	
func getLanguage():
	return Data.currentLanguage
	
func setLanguage(languagePicked = "en"):
	Data.currentLanguage = languagePicked
	Data.hasPickedLanguage = true
	Save()
	
func getHasPickedLanguage():
	return Data.hasPickedLanguage