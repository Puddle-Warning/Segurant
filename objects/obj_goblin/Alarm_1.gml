/// @description Create the attack hitbox meant to actually hit the player

// Create the atack's hitbox's instance and give it the right sprite
instance_create_layer(x + (image_xscale*10), y - 7, "Enemies", obj_hostile_hitbox, {sprite_index: spr_goblin_attack_hitbox, image_xscale: image_xscale});
