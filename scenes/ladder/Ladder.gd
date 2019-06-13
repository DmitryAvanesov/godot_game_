extends Sprite

var gap = 30

func _physics_process(delta):
	if abs(GLOBAL.playerCoordinates.x - position.x) < gap &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < gap * 7:
		GLOBAL.ladderCounter += 1