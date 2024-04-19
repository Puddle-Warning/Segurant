// Interaction constants for the different interactions
enum interactions {
    nothing = 0,
    push = 1,
    carry = 2,
    activate = 3
}

global.kb_inputs = {
    left : 81, // Q
    right : 68, // D
    interaction : 69, // E
    block : 83, // S
    jump : 32, // SPACE
    pause : 27 // ESC
};

// Some default speed variables
global.default_falling_speed = 5;
global.default_throw_speed = 10;
global.default_x_speed = 2.5;
global.reduced_x_speed = 1.25;

// Global variable set to true when the player has died
global.died = false;

// Global variable set to true when moving from one room to another
global.changing_room = false;

// Camera variables
global.view_width = 1920/6;
global.view_height = 1080/6;

global.window_scale = 3;

global.window_width = view_width*global.window_scale;
global.window_height = view_height*global.window_scale;
