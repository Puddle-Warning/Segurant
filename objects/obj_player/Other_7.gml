/// @description Changing sprites after certain sprites end

// After attack sprite, revert to the special idle sprite
if sprite_index == spr_player_attack {
	sprite_index = spr_player_idle_2;
	// Reset in_animation to allow inputs
	in_animation = false;
}
// Attempt to make the jump animation more natural by
// freezing the sprite to its last image when ascending
else if sprite_index == spr_player_jump {
	image_index = 3;
}
// Start blocking animation loop after its initialization ended
else if sprite_index == spr_player_block && blocking {
	sprite_index = spr_player_block_loop;
}
