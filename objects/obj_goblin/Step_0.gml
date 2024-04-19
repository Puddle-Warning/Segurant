/// @description Frame per frame behaviour

enemy_condition = !in_animation;

// React to the player or not
path_and_reaction_enemy(in_animation);

// Set movements if in knockback animation
knockback_goblin();

// Move accordingly
move_enemy();

// Animate the object
animate_goblin(spr_goblin_run, spr_goblin_idle, spr_goblin_idle, spr_goblin_idle, spr_goblin_hit);
