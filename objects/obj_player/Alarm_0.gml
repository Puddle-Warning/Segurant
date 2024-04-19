/// @description Create the player's attack's hitbox

instance_create_layer(x + (image_xscale*12), y - 19, "Player", obj_player_attacks_hitbox, {sprite_index: spr_p_attack1_hitbox, image_xscale: image_xscale});
