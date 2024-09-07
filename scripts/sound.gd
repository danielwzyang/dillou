extends AudioStreamPlayer2D

func playsound(sound):
	stream = load(sound)
	play()
