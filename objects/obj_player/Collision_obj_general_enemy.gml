/// @description Behaviour when hit by body of enemy

// Decrease HPs only when not blocking, not invincible and actively moving towards the enemy
if !blocking && !invincible && move_x != 0 && sign(move_x) == get_x_sign_to_direction(x, y, other.x, other.y) {
	hp--;
	// Start knocking back the player in the opposite direction to the one it's facing
	knockback_trigger(self, other, -image_xscale, true);
}

// YOU DIED
if (hp == 0) {
	kill_player();
}