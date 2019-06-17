extends Area2D

var gap = 50 * GLOBAL.sceneScaleCoef

func _physics_process(delta):
	if abs(GLOBAL.playerCoordinates.x - position.x) < gap * scale.x &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < gap * scale.y * 4.5:
		GLOBAL.ladderCounter += 1
		GLOBAL.ladderCoordinates = position
		GLOBAL.ladderSize = scale.y