extends AudioStreamPlayer


var ambient_songs_path = ["res://Soundtrack/AscensaoDoHomem.ogg", "res://Soundtrack/TernuraDoEntardecer.ogg", "res://Soundtrack/Petrichor.ogg", "res://Soundtrack/Jasmim.ogg"]
var cinematic_songs_path = ["res://Soundtrack/TemAlguemAi.ogg", "res://Soundtrack/IndianContact.ogg", "res://Soundtrack/BeeMission.ogg"]
var current_path
var songs = [0,1,2,3]

var song 
var sec_pos

var cinematic_playing = false # avoid ambient song interrupting cinematic
var current_cinematic_index = 0

func _ready():
	randomize()
	play_ambient_songs([0])
	if Main.debug_version:
		AudioServer.set_bus_volume_db(1, -80)
	else:
		AudioServer.set_bus_volume_db(1, -12)



func play_ambient_songs(song_list: Array):
	if !cinematic_playing: #check if theresnt a cinematic song playing
		if song_list.size() > 0:
			var rand_value = randi() % song_list.size()
			song = song_list.pop_at(rand_value) #randi_range(0, song_list.size())
			print("song: ", song)
			current_path = ambient_songs_path[song]
			stream = load(current_path)
			volume_db = -80
			var tween = create_tween()
			tween.tween_property(self, "volume_db", 0, 2)
			play()
		else:
			print("song is empty, no problem new array is coming up!")
			songs.clear()
			for i in ambient_songs_path.size():
				songs.insert(i,i)
				print("array: ", songs)
			play_ambient_songs(songs)
	

func play_cinematic():
	cinematic_playing = true
	on_stop_soundtrack()
	stream = load(cinematic_songs_path[current_cinematic_index])
	current_cinematic_index += 1
	play()


func _on_finished(): #in theory every cinematic should be a loop but just in case...
	if cinematic_playing:
		cinematic_playing = false
	else:
		songs.remove_at(song) #removes previus song
		await get_tree().create_timer(randi_range(1,12)).timeout
#		print("finished, this is the new array: ", songs)
		play_ambient_songs(songs)


func on_stop_soundtrack():
	sec_pos = get_playback_position()
	stop()

func on_return_soundtrack():
	if cinematic_playing:
		cinematic_playing = false
	stream = load(current_path)
	play(sec_pos)
	volume_db = -80
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0, 2)


func _on_bonfire_bonfire_entered(): #called by bonfire
	play_cinematic()


func _on_amulet_area_entered(_area):#called by amulet
	volume_db = 0
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, 4)
	await tween.finished # awaiting for portrait to be shown
	on_return_soundtrack()

func _on_beehive_tree_honey_collected():
	volume_db = 0
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, 4)
	await tween.finished # awaiting for portrait to be shown
	on_return_soundtrack()

func on_indian_contact(): #called by anaje 
	play_cinematic()

func on_bee_mission():
	play_cinematic()

func set_filter(is_paused): #called from pause_menu
	var fx: AudioEffectEQ = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	if is_paused:
		fx.set_band_gain_db(3, linear_to_db(0.0))
		fx.set_band_gain_db(4, linear_to_db(0.0))
		fx.set_band_gain_db(5, linear_to_db(0.0))
	else:
		fx.set_band_gain_db(3, linear_to_db(1.0))
		fx.set_band_gain_db(4, linear_to_db(1.0))
		fx.set_band_gain_db(5, linear_to_db(1.0))




