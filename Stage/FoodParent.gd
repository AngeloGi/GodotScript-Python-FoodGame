extends Area2D

var isMovingIntoScene = true
var eatRequested = false
var isFoodJunk = true
var speedMultiplier = 1
var rand = null
var isHpDrop = false

func _ready():
	position.x = 800
	position.y = 900
	speedMultiplier = get_parent().speedMultiplierForFood
	randomize()
	var hpDropChance = rand_range(0,1)  # try to random drop
	if hpDropChance < 0.08 and get_parent().lives < 3:  # x% chance to drop HP powerup, when lives < 3
		isHpDrop = true
		$CollisionBox/FoodSprite.texture = get_parent().hpDrop
	else:        # If no drops randomed, serve food instead
		if randi() % 2 == 0:
			isFoodJunk = true
			decideFood(isFoodJunk)
		else:
			isFoodJunk = false
			decideFood(isFoodJunk)

func _process(delta):
	if isMovingIntoScene:
		moveIntoScene()
	if eatRequested:
		eatFood()
	speedMultiplier = get_parent().speedMultiplierForFood

func moveIntoScene():                   # Move food into place when spawned
	if position.x > 360:
		if !get_parent().gameIsRunning: # Check to destroy sprite on game over (visual bug solver)
			self.queue_free()
		else:
			position.x -= 15 * speedMultiplier
	else:
		isMovingIntoScene = false
		position.x = 360
		get_parent().foodIsServed = true         # Tell Stage that food is ready, TimeBar starts with this
		get_parent().showControls(true)
		if !get_parent().gameIsRunning:           # Check to destroy sprite on game over
			self.queue_free()

func eatFood():                        # Called by stage when eat is pressed
	if position.y < 1300:
		position.y += 25 * speedMultiplier
		scale.x += 0.1 * speedMultiplier            # closeup effect
		scale.y += 0.125 * speedMultiplier          #
		randomize()
		if rand == null:
			rand = randi() % 2                   # ranadom left / right rotate
		if rand == 0:                            # Rotate effect
			$CollisionBox/FoodSprite.rotate(0.1)
		else:
			$CollisionBox/FoodSprite.rotate(-0.1)
	else:
		self.queue_free()

func hitFood(currentWeapon):                # Called by stage when hit is pressed:
	match currentWeapon.animationType:                  # plays matching animation
		"sharp":
			$Animation.playback_speed = 1 * speedMultiplier
			$Animation.play("SlashFood")     # Plays hit animations
		"blunt":
			$Animation.playback_speed = 1 * speedMultiplier
			$Animation.play("CrushFood")     # Plays hit animations
		_:                                   # default (no match)
			pass

func decideFood(foodIsJunk):             # Code to pick sprite, same logic as blun enemy spawn
	if foodIsJunk:
		var foodGroup = get_parent().foodGroups["Junk"]
		var RandomPick = foodGroup[randi() % foodGroup.size()]
		$CollisionBox/FoodSprite.texture = get_parent().foods[RandomPick]
	else:
		var foodGroup = get_parent().foodGroups["Healthy"]
		var RandomPick = foodGroup[randi() % foodGroup.size()]
		$CollisionBox/FoodSprite.texture = get_parent().foods[RandomPick]

func _on_Animation_animation_finished(anim_name):
	if anim_name != null:
		self.queue_free()
