extends Sprite

const gap = 75
var distance
var heightDifference

func _physics_process(delta):
	distance = position.x - GLOBAL.playerCoordinates.x
	heightDifference = abs(position.y - GLOBAL.playerCoordinates.y)
		
	if distance > 0 && distance < gap && heightDifference < gap * 2:
		GLOBAL.rightCounter += 1
		
	if distance < 0 && distance > -gap && heightDifference < gap * 2:
		GLOBAL.leftCounter += 1