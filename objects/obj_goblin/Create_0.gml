/// @description Setting up all the variables for this object

// Speed variables
x_speed = 1.5;
path_x_speed = .5;
knockback_speed = 5;
max_falling_speed = 5;

// Jump variables
jump_trigger = false;
jump_condition = false;
jump_speed = 6;

// Movement variables
move_x = 0;
move_y = 0;

// Attack variables
attack_hitbox_offset = 29;
attack_sprite = spr_goblin_attack;
init_attack_buffer = 30;
cur_attack_buffer = 30;

// State variables
jumping = false;
pursuing = false;
attacking = false;
on_path = false;
falling = false;
in_animation = false;
knockedback = false;
invincible = false;

// Invicibility frames
init_iframes = 0;
iframes = init_iframes;

// Pre-set path variables
path_points = [x + 150, x - 150];
trigger_distance = 150;
aggro_distance = 160;
attack_reach_distance = 15;
enemy_condition = true;
init_path_buffer = 60;
cur_path_buffer = 60;

// Relation to the player variables
direction_to_player = get_x_sign_to_direction(x, y, obj_player.x, obj_player.y);
distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);

// Defining methods for this object
path_and_reaction_enemy = method(id, move_on_path_and_react);
move_enemy = method(id, move_physical_object);
animate_goblin = method(id, animate_object);
knockback_goblin = method(id, knockback_set_move);

// Initializing the object's HPs
hp = 5;

// This object does have a custom saving method
custom_save = true;

function save_this_object() {
    var data = {
        x : x,
        y : y,
        path_points : path_points
    };
    return data;
}
