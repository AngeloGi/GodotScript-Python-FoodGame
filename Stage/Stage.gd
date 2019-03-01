extends Node

# Game Vars
var gameIsRunning = false
var baseScore = 10       
var currentStreak = 0   
var maxStreakThisGame = 0                           
var currentMultiplier = 1
var myScore = 0      
var speedBonus = 0                               
var startTimeOut = 4  
var roundsPlayed = 0
var timeBarPercent = 1.0
var foodIsServed = false
var currentFood
var speedMultiplierForFood = 1                    # Increase gradually, so food appears faster (harder)
var foods = {}
var foodGroups = {
Healthy = ["Cabbage","Carrot","Eggplant","Garlic","Lettuce","Mushroom","Onion","Pepper","Tomato","Zucchini","Pepper"],\
Junk = ["Gello","Burger","Cake","Cake2","Cookie","Doughnut","Fries","Gyro","Hotdog","Icecream","Macaron","Muffin","Noodles","Pizza"]}
var hpDrop = preload("res://Art/Heart.png")
var currentWeapon
var hearts 
var lives
var hasLostHealth = false
var backPressed = false

# Bar Vars
var barMinValue = 0
var barMaxValue = 2
var barValue = 2
var barDecrement = 1.0

# UI effect Vars
var upDown = false
var lettersAreRot
var isStartSequence = true 
var multy
var multyCanRot = false
var multyleft = false

func _init():
	foods = {
		Cabbage = preload("res://Art/Healhty/Cabbage.png"),
		Carrot = preload("res://Art/Healhty/Carrot.png"),
		Eggplant = preload("res://Art/Healhty/Eggplant.png"),
		Garlic = preload("res://Art/Healhty/Garlic.png"),
		Lettuce = preload("res://Art/Healhty/Lettuce.png"),
		Mushroom = preload("res://Art/Healhty/Mushroom.png"),
		Onion = preload("res://Art/Healhty/Onion.png"),
		Pepper = preload("res://Art/Healhty/Pepper.png"),
		Tomato = preload("res://Art/Healhty/Tomato.png"),
		Zucchini = preload("res://Art/Healhty/Zucchini.png"),
		
		Gello = preload("res://Art/Junk/Gello.png"),
		Burger = preload("res://Art/Junk/Burger.png"),
		Cake = preload("res://Art/Junk/Cake.png"),
		Cake2 = preload("res://Art/Junk/Cake2.png"),
		Cookie = preload("res://Art/Junk/Cookie.png"),
		Doughnut = preload("res://Art/Junk/Doughnut.png"),
		Fries = preload("res://Art/Junk/Fries.png"),
		Gyro = preload("res://Art/Junk/Gyro.png"),
		Hotdog = preload("res://Art/Junk/Hotdog.png"),
		Icecream = preload("res://Art/Junk/Icecream.png"),
		Macaron = preload("res://Art/Junk/Macaron.png"),
		Muffin = preload("res://Art/Junk/Muffin.png"),
		Noodles = preload("res://Art/Junk/Noodles.png"),
		Pizza = preload("res://Art/Junk/Pizza.png")}
		

func _ready():
	AudioManager.mainMenuStop() #stops Menu music
	AudioManager.InGamePlay() #Play InGameMusic
		
	$TimeBar.max_value = barMaxValue               # initialize bar                                
	$TimeBar.min_value = barMinValue               #
	$TimeBar.value = barMaxValue                   # Set to max for game start
	currentWeapon = load("res://Stage/Weapon.tscn").instance() 
	add_child(currentWeapon)
	hearts = [$MyCanvas/PlayUI/Life1,$MyCanvas/PlayUI/Life2,$MyCanvas/PlayUI/Life3]
	lives = 3
	livesProcess(0.01)
	for heart in hearts:
		heart.scale.y = 0
		heart.scale.x = 0
	$MyCanvas/PlayUI/MultiSprite.scale.y = 0.5
	$MyCanvas/PlayUI/MultiSprite.scale.x = 0.5
	
	# Localization {
	
	$MyCanvas/PlayUI/Eat/Eat.set_text(tr("EAT"))
	$MyCanvas/PlayUI/Hit/Hit.set_text(tr("HIT"))
	$MyCanvas/GameOverUI/Retry/Retry.set_text(tr("RETRY"))
	$MyCanvas/GameOverUI/ToMenu/ToMenuLAbel.set_text(tr("TO MMENU"))
	$MyCanvas/GameOverUI/GameOver/GameOver.set_text(tr("GAME_OVER"))
	
	# }
	
	
	
func _process(delta):
	if isStartSequence:                            # Stuff during the start of the game
		drawStartSequence(delta)

	if gameIsRunning:                              # Functions called only while game is running
		updateTimeBar(delta)
		updateScore()
		updateMultiplier()
		livesProcess(delta)
		
	if !gameIsRunning:                             # Functions called only while game is over
		if !$UpDown.is_stopped():
			updateGameOverScreen(delta)
			
	if $MyCanvas/PlayUI/Speedy.modulate.a > 0:
			$MyCanvas/PlayUI/Speedy.modulate.a -= 1 * delta
	if $MyCanvas/PlayUI/Speedy.position.y > 200:
		$MyCanvas/PlayUI/Speedy.position.y -= 100 * delta

func updateMultiplier():   # makes multiplier label nicer
	multy = stepify((currentMultiplier),0.1)
	        
	if multy < 1.1:                         #When multiplier is more than 5 then the Multiplier letters start rotating
		multyCanRot = false
		$MyCanvas/PlayUI/MultiSprite.visible = false
	elif multy >= 1.1 and  multy < 10:
		$MyCanvas/PlayUI/MultiSprite.visible = true
		if multyCanRot == false:
			$MyCanvas/PlayUI/MultiSprite/MultyRot.start()
			multyCanRot = true
	else:
		multy = 10
		multyCanRot = true

	$MyCanvas/PlayUI/MultiSprite/Multiplier.modulate.g = 0.1 - multy * 0.1
	$MyCanvas/PlayUI/MultiSprite/Multiplier.modulate.b = 0.9 - multy * 0.1
	
	$MyCanvas/PlayUI/MultiSprite/MultyRot.wait_time = 0.5 - 0.4 * (multy / 10)
	$MyCanvas/PlayUI/MultiSprite.scale.y = 0.5 + (multy /22.0)
	$MyCanvas/PlayUI/MultiSprite.scale.x = 0.5 + (multy /22.0)

	if multyCanRot == true:       #If letters have started Rotating :
			
		if multyleft == true:
			$MyCanvas/PlayUI/MultiSprite.set_rotation(-0.18 )
		else:
			$MyCanvas/PlayUI/MultiSprite.set_rotation(0.18 )
	else:
		$MyCanvas/PlayUI/MultiSprite.set_rotation(0)
		$MyCanvas/PlayUI/MultiSprite.scale.y = 0.5
		$MyCanvas/PlayUI/MultiSprite.scale.x = 0.5
		$MyCanvas/PlayUI/MultiSprite/MultyRot.stop()
		

func updateTimeBar(delta):
	$MyCanvas/PlayUI/TimeLeft.set_text("%.1f" % $TimeBar.value + "s")   # time counter label update
	$MyCanvas/PlayUI/TimeLeft.modulate.g = $TimeBar.modulate.g          # Match bar color
	$MyCanvas/PlayUI/TimeLeft.modulate.r = $TimeBar.modulate.r          #
	if foodIsServed:
		barValue -= barDecrement * delta    # subs 1 barDecrement per second from value
	if barValue <= 0:                       # check for timeout / lose
		removeLife()
		barValue = barMaxValue
	
	$TimeBar.value = barValue
	$TimeBar.max_value = barMaxValue                                                
	$TimeBar.min_value = barMinValue
	timeBarPercent = barValue / barMaxValue
	$TimeBar.modulate.g = (barValue/barMaxValue)  # Change bar color depending on time left
	$TimeBar.modulate.r = (barMaxValue/barValue)
           
func updateScore():
	$MyCanvas/PlayUI/Score.set_text(str(myScore))
	$MyCanvas/PlayUI/MultiSprite/Multiplier.set_text("x"+str(float(stepify((currentMultiplier),0.1))))
	$MyCanvas/PlayUI/CurrentStreak.set_text(tr("CURRENT_STREAK") + str(currentStreak))
	$MyCanvas/PlayUI/BestStreak.set_text(tr("BEST_STREAK") + str(maxStreakThisGame))
	if currentStreak >= maxStreakThisGame: 
		maxStreakThisGame = currentStreak

func gameOver(): # on game over do things
	gameIsRunning = false
	PlayerData.SetHighScore(myScore)
	currentFood.queue_free()
	currentWeapon.queue_free()
	$UpDown.start()
	$TimeBar.visible = false  # hide timer
	$MyCanvas/PlayUI.visible = false # in game ui invisible
	$MyCanvas/GameOverUI.visible = true # Game over menu visible
	$MyCanvas/GameOverUI/ScoreLabel.set_text(tr("SCORE") + "\n" + str(myScore)) # gives to the game over label  your score

func updateGameOverScreen(delta):
	if upDown:
		$MyCanvas/GameOverUI/GameOver.position.y += 40 * delta
	else:
		$MyCanvas/GameOverUI/GameOver.position.y -= 40 * delta

func _on_UpDown_timeout():
	upDown = not upDown

func _on_Eat_pressed():
	if foodIsServed:     
		AudioManager.eatPlay()     # Check if food is fully served before allowing input
		if currentFood.isHpDrop:       # Check if HP drop instead of food
			lives = clamp((lives+1),0,3)  # increase lives by one with max of 3
			calculateScore(true,true)
		else:
			if currentFood.isFoodJunk: 
				calculateScore(true,true)
			else:
				calculateScore(false,true)           

func _on_Hit_pressed():
	if foodIsServed:
		AudioManager.hitPlay()                    # Check if food is fully served before allowing input
		currentWeapon.playWeaponAnimation()
		if !currentFood.isFoodJunk:
			calculateScore(true,false)
		else:
			calculateScore(false,false)

func calculateScore(isCorrectChoice, isEat):
	if isCorrectChoice:      # Code for score when player made right call
		if roundsPlayed > 10:          #
			baseScore += 5             # Rounds played bonus
			if roundsPlayed > 30:      #
				baseScore += 15        #

		if timeBarPercent >= 0.75:     #
			speedBonus = 2             #
			notifySpeedy(speedBonus)   #
		elif timeBarPercent >= 0.5:    # Speed bonus
			speedBonus = 1.5           #
			notifySpeedy(speedBonus)   # 
		else:                          # 
			speedBonus = 1             #

		myScore += baseScore * currentMultiplier * speedBonus     # Sum
		myScore = round(myScore)
		barMaxValue = getRoundTime() # calculate next round time
		currentStreak += 1           # Increase player current streak
		if currentStreak >= 3 and currentMultiplier < 10:
			currentMultiplier += 1
	else:                           # if player made wrong call
		removeLife()                          
	if isEat:
		currentFood.eatRequested = true
	else:
		currentFood.hitFood(currentWeapon)
	barValue = barMaxValue
	foodIsServed = false
	roundsPlayed += 1         # Increase rounds played tally
	takeBreak()

func _on_Menu_pressed():
	AudioManager.clickPlay()
	get_tree().change_scene("res://Menu.tscn") # go to main menu

func getRoundTime():        # Lowers time for each round
	return clamp(2 - ((float(roundsPlayed)/35) + (float(currentMultiplier)/12)),0.45,2)
	                         # First number is round 1 starting time
	                         # Increase /x numbers to decrease their affect on diffuculty
                             # Adjust 0.x number to set minimum time allowed for each round

func _on_Retry_pressed():
	AudioManager.clickPlay()
	get_tree().reload_current_scene() # restart scene

func _on_RotStart_timeout():
	lettersAreRot = true

func _on_StartTimer_timeout():
	if startTimeOut > 1 and startTimeOut < 5:
		lettersAreRot = true
		$RotStart.start()                                       #start Rot timer
		lettersAreRot = false                                   #stop rotating letters
		$Start/StartLabel.set_text(str(startTimeOut - 1))
	elif startTimeOut == 1:
		$RotStart.stop()
		$Start.set_rotation(0)
		lettersAreRot = false
		$Start/StartLabel.set_text(tr("START"))
	elif startTimeOut == 0:       
		isStartSequence = false                   
		$TimeBar.visible = true
		$MyCanvas/PlayUI.visible = true     # make all UI visible when start
		gameIsRunning = true
		$Start.visible = false
		$RotStart.stop()
		$StartTimer.stop()
		serveFood()
	startTimeOut -= 1

func drawStartSequence(delta):
	if lettersAreRot and startTimeOut > 0:
		$Start.rotate(10 * delta)
		$Start.scale.x -= 0.04
		$Start.scale.y -= 0.04
	elif lettersAreRot == false and startTimeOut > 0:
		$Start.set_rotation(0)
		$Start.scale.x += 0.04
		$Start.scale.y += 0.04
	elif startTimeOut == 0 :
		$Start.scale.x += 0.005
		$Start.scale.y += 0.005

func takeBreak(breakTime = 1.5):                 # Wait between serves, breakTime adjusted
	if $BreakTimer.is_stopped():                 # to make game harder as run continues
		$BreakTimer.wait_time = clamp((breakTime / speedMultiplierForFood),0.2,1.5)  # faster serve as game goes on
		$BreakTimer.start()
		showControls(false)

func showControls(showControls):               # Show or hide controls when active / inactive
	if showControls:
		$MyCanvas/PlayUI/Eat.visible = true
		$MyCanvas/PlayUI/Hit.visible = true
	else:
		$MyCanvas/PlayUI/Eat.visible = false
		$MyCanvas/PlayUI/Hit.visible = false

func _on_BreakTimer_timeout():                   # Break ends
	serveFood()
	
func serveFood():                                # Called to serve food
	speedMultiplierForFood += 0.08               # Adjust how much faster food gets served every time
	currentFood = load("res://Stage/FoodParent.tscn").instance() 
	add_child(currentFood)

func _on_MultyRot_timeout():
	multyleft = not multyleft
	
func removeLife():
	lives -= 1
	currentMultiplier = 1                 # Reset multiplier
	if currentStreak > maxStreakThisGame:
		maxStreakThisGame = currentStreak     # Save max streak for UI and stats
	currentStreak = 0                     # reset streak
	barMaxValue = getRoundTime()
	
func livesProcess(delta):
	if lives == 3:
		if hearts[2].scale.y <= 0.35 and hasLostHealth:
				hearts[2].scale.y += 0.7 * delta
				hearts[2].scale.x += 0.7 * delta
	if lives == 2:
		hasLostHealth = true
		if hearts[2].scale.y > 0 :
			hearts[2].scale.y -= 0.5 * delta
			hearts[2].scale.x -= 0.5 * delta
		if hearts[1].scale.y <= 0.35 and hasLostHealth:
				hearts[1].scale.y += 0.7 * delta
				hearts[1].scale.x += 0.7 * delta
				
	if lives == 1:
		if hearts[1].scale.y > 0 :
			hearts[1].scale.y -= 0.5 * delta
			hearts[1].scale.x -= 0.5 * delta
		if hearts[0].scale.y <= 0.35 and hasLostHealth:
				hearts[0].scale.y += 0.7 * delta
				hearts[0].scale.x += 0.7 * delta
	if lives <= 0:
		gameOver()
	
	if lives > 2:
		for heart in hearts:
			if heart.scale.y < 0.35:
				heart.scale.y += 0.3 * delta
				heart.scale.x += 0.3 * delta

func _notification(what):                   # Code to handle android back button
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST: 
		if !backPressed:
			backPressed = true
			$BackWarning.visible = true
			$ExitTimer.start(1)
		else:
			get_tree().change_scene("res://Menu.tscn")

func _on_ExitTimer_timeout():
	backPressed = false
	$BackWarning.visible = false

func notifySpeedy(speedBonus):                # Called to notify user of fast pick
	$MyCanvas/PlayUI/Speedy.visible = true
	match speedBonus:
		2:
			$MyCanvas/PlayUI/Speedy.position.y = 500
			$MyCanvas/PlayUI/Speedy/SpeedyNotify.set_text(tr("SWIFT") + " " + tr("BONUS") + " x2")
			$MyCanvas/PlayUI/Speedy.modulate.a = 1
			$MyCanvas/PlayUI/Speedy.modulate.r = 1
			$SpeedyNotifyTimer.start(1)
		1.5:
			$MyCanvas/PlayUI/Speedy.position.y = 500
			$MyCanvas/PlayUI/Speedy/SpeedyNotify.set_text(tr("SPEEDY") + " " + tr("BONUS") + " x1.5")
			$SpeedyNotifyTimer.start(1)
			$MyCanvas/PlayUI/Speedy.modulate.a = 1
			$MyCanvas/PlayUI/Speedy.modulate.r = 0.1
		_:
			pass

func _on_SpeedyNotifyTimer_timeout():       # Fast notification hidden
	$MyCanvas/PlayUI/Speedy.visible = false


