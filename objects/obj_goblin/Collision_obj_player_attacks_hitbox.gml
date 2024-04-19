/// @description Behaviour when hit by the player's attack

//Reducing the HPs by 1 per hit
hp -= 1;

// Flash the sprite in red to show that it was hit
image_blend = c_red;
// Reset the sprite to it's original color later
alarm_set(0,1);

// Start the death process
if (hp == 0) {
	audio_play_sound(snd_enemy_death, 1, false);
	sprite_index = spr_goblin_death;
	// Make sure the animation plays
	image_speed = 1;
	in_animation = true;
}
// if not dead then knockback the enemy
else {
	knockback_trigger(self, other, other.image_xscale);
	// Start pursing the player once got hit
	pursuing = true;
}