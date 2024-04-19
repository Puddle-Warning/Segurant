/// @description Insert description here

window_set_size(global.window_width, global.window_height);
alarm[0] = 1;

surface_resize(application_surface, global.window_width, global.window_height);

// Initial speed to maximum to prevent weird camera movement when game loads
cam_speed = 1;
