extends Node2D

func _physics_process(delta):
	$Label.text = str($Enemy.seesPlayer) + "  " + str($Enemy.suspicions)
