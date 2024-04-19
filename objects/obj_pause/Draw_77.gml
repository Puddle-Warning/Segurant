/// @description Initiate pause menu

// The initialization of the pause menu has to be done in this event because
// we have to wait for everything to be drawn before we can pause
// However the menu drawing proper is in the Draw GUI event

// Draw the frozen image to the screen when paused
if global.pause {
    surface_set_target(application_surface);
    // If the pause surface exists then draw it
    if surface_exists(global.pause_surface)
        draw_surface(global.pause_surface, 0, 0);
    // Otherwise get the backup in the buffer and draw that
    else {
        global.pause_surface = surface_create(global.window_width, global.window_height);
        buffer_set_surface(global.pause_surface_buffer, global.pause_surface, 0);
    }
    surface_reset_target();
}

// Toggle the pause menu
if keyboard_check_pressed(global.kb_inputs.pause) {
    // If not paused then pause
    if !global.pause {
        global.pause = true;
        cursor = 0;
        // Deactivate all instances except the pause object (this is effectively pausing the game)
        instance_deactivate_all(true);
        // Disable alpha blending because we just need the RGB
        gpu_set_blendenable(false);

        // NOTE:
        // If we want to pause animations of sprites, tiles, room backgrounds etc
        // we will need to do that seperately
        // e.g. create a pause_animations() function and call it here

        // Capture the game's image to draw as a still image
        global.pause_surface = surface_create(global.window_width, global.window_height);
        surface_set_target(global.pause_surface);
        draw_surface(application_surface, 0, 0);
        surface_reset_target();

        // Create a backup of the image in a buffer
        if buffer_exists(global.pause_surface_buffer)
            buffer_delete(global.pause_surface_buffer);
        global.pause_surface_buffer = buffer_create(global.window_width * global.window_height * 4, buffer_fixed, 1);
        buffer_get_surface(global.pause_surface_buffer, global.pause_surface, 0);

        // Re-enable alpha blending
        gpu_set_blendenable(true);
    }
    // Otherwise go back to parent menu or un-pause
    else
        return_menu();
}
