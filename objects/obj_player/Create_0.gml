/// @description General variables definitions

// Speed variables
x_speed = global.default_x_speed;
knockback_speed = 5;
max_falling_speed = global.default_falling_speed;

// Jump variables
jump_trigger = keyboard_check(vk_space);
jump_condition = sprite_index != spr_player_attack;
jump_speed = 6;

// Movement variables
move_x = 0;
move_y = 0;

// State variables
jumping = false;
falling = false;
blocking = false;
knockedback = false;
in_animation = false;
invincible = false;
interacting = interactions.nothing;
input_condition = !in_animation && !blocking && !knockedback;

// Invicibility frames
init_iframes = 120;
iframes = init_iframes;

// Defining methods for this object
move_player = method(id, move_physical_object);
knockback_player = method(id, knockback_set_move);
iframes_player = method(id, check_iframes);

// Initializing the object's HPs
max_hp = 3;
hp = max_hp;

// Initialize the object's stamina
init_regen_stamina = 250;
regen_stamina = init_regen_stamina;
max_stamina = 3;
cur_stamina = max_stamina;

// BEGIN HELPER FUNCTIONS FOR THE PLAYER OBJECT

function save_player_data() {
    var player_data = {
        x : x,
        y : y,
        hp : hp
    };
    return player_data;
}

function kill_player() {
    global.died = true;
	hp = max_hp;
	room_restart();
}

// END HELPER FUNCTIONS FOR THE PLAYER OBJECT
