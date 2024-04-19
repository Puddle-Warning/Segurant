/// @description Behaviour when hit by another attack hitbox

// Decrease HPs only when not blocking
if !blocking && !invincible {
	hp--;
	// Start knocking back the player
	knockback_trigger(self, other, other.image_xscale, true);
}
// Otherwise we're blocking so decrease stamina
else if !invincible {
	cur_stamina--;
}

// YOU DIED
if (hp == 0) {
	kill_player();
}