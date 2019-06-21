extends Area2D

var gap = 100 * GLOBAL.sceneScaleCoef

func _physics_process(delta):
	if abs(GLOBAL.playerCoordinates.x - position.x) < gap * scale.x &&\
	abs(GLOBAL.playerCoordinates.y - position.y) < gap * scale.y * 4.5:
		GLOBAL.goNextCounter += 1
		$Label.visible = true
	if GLOBAL.goNextCounter==0:
		$Label.visible = false