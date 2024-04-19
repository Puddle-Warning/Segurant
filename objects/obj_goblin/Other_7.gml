/// @description End of animation code

// Return to idle after the attack animation ends
if sprite_index == spr_goblin_attack {
	sprite_index = spr_goblin_idle;
	// Reset in_animation to allow inputs
	in_animation = false;
	// Reset attacking to allow other actions
	attacking = false;
}
// Destroy the object after its death animation
else if sprite_index == spr_goblin_death {
	instance_destroy();
}




