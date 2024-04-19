/*
    Global variable representing containing the entire pause menu
*/
global.pause_menu = {
	name: "Pause",
	sub: [
		{
			name: "Save",
			sub: false,
			action: function() {construct_save_data(); save_to_file();},
			parent: "Pause"
		},
		{
			name: "Load",
			sub: [
				{
					name: "Reload last checkpoint",
					sub: false,
					action: function() {global.current_menu = global.pause_menu; return_menu(); load_last_checkpoint();},
					parent: false
				},
				{
					name: "Reload last save",
					sub: false,
					action: function() {global.current_menu = global.pause_menu; return_menu(); load_save_data();},
					parent: false
				},
                {
					name: "Back",
					sub: false,
					action: return_menu,
					parent: false
				}
			],
			action: false,
			parent: "Pause"
		},
		{
			name: "Exit game",
			sub: false,
			action: function() {construct_save_data(); save_to_file(); game_end();},
			parent: "Pause"
		},
        {
            name: "Return to game",
            sub: false,
            action: return_menu,
            parent: false
        }
	],
	action: false,
	parent: false
};

/*
    draw_pause_menu()

    Draw the background of the given pause menu and its title

    @param spr_width  width of the sprite used for the background
    @param width      scale integer of the background sprite to which it need to be streched in x direection
    @param height     scale integer of the background sprite to which it need to be streched in y direction
    @param x_pos      x position of the menu
    @param y_pos      y position of the menu
    @param menu_title name of the menu to be displayed

    @return integer   y position at which the rest of the menu can be drawn
*/
function draw_pause_bkg(spr_width, width = 1, height = 1, x_pos = 0, y_pos = 0, menu_title = "Pause") {
    var y_offset = 45;

    // Set transparency for black backdrop
    draw_set_alpha(.3);
    // Draw black backdrop
    draw_rectangle_color(0, 0, global.window_width, global.window_height, c_black, c_black, c_black, c_black, false);
    // Reset transparency
    draw_set_alpha(1);

    // Draw sprite background of the menu
    draw_sprite_ext(spr_pause_bkg, 0, x_pos, y_pos, width, height, 0, c_white, 1);

    // Alight menu name to the center of the menu
    draw_set_halign(fa_center);
    draw_set_colour(c_white);
    // Draw manu name
    draw_text(x_pos + floor(spr_width * width / 2), y_pos + y_offset, menu_title);
    // Reset text drawing origin
    draw_set_halign(fa_left);

    // Return first y position after manu title at which stuff can be written
    return 2 * y_offset + y_pos + font_size;
}

/*
    draw_sub_menu()

    Draw the menu items and colors the one selected

    @param menu     list of sub menus which name should be drawn and interacted with
    @param gap      real number of pixels between drawn items
    @param x_offset real number of pixels from left of the view where the pause menu starts
    @param y_offset real number of pixels from top of the window from which the items can be drawn

    @return         nothing
*/
function draw_sub_menu(menu, gap, x_offset, y_offset) {
    var len = array_length(menu);
    var x_mouse = device_mouse_x_to_gui(0);
    var y_mouse = device_mouse_y_to_gui(0);
    var name_length, mouse_point;
    for (var i = 0; i < len; i++) {
        name_length = string_length(menu[i].name)*font_size;
        mouse_point = point_in_rectangle(x_mouse, y_mouse, x_offset + gap - 5, y_offset - 5, x_offset + gap + name_length + 5, y_offset + font_size + 5);
        if mouse_point && mouse_check_button_released(mb_left) {
            cursor = 0;
            if is_array(menu[i].sub)
                global.current_menu = menu[i];
            else if !menu[i].sub {
                menu[i].action();
                cursor = i;
            }
        }
        else if mouse_point
            cursor = i;
        if cursor == i
            draw_set_colour(clr_selected);
        else
            draw_set_colour(clr_unselected);
        draw_text(x_offset + gap, y_offset, menu[i].name);
        y_offset += gap + font_size;
    }
}

function return_menu() {
    if global.current_menu.name != global.pause_menu.name {
        global.current_menu = find_menu(global.current_menu.parent);
        return;
    }
    global.pause = false;
    global.current_menu = global.pause_menu;

    // Effectively un-pause by reactivating everything
    instance_activate_all();
    // Free the surface if it exists
    if surface_exists(global.pause_surface)
        surface_free(global.pause_surface);
    // Free the buffer if it exists
    if buffer_exists(global.pause_surface_buffer)
        buffer_delete(global.pause_surface_buffer);
}

/*
    find_menu()

    Finds and returns the menu with name name in the paue menu

    @param name string name of the menu to find

    @return     array of the menu found with name name, false if not found
*/
function find_menu(name) {
    if name == global.pause_menu.name
        return global.pause_menu;
    return crawl_menu(global.pause_menu.sub, name);
}

/*
    crawl_menu()

    Crawls the pause menu's sub menus to find and return the one with name name

    @param menu_list list of menus to crawl
    @param name      string name of the menu to find

    @return          array of the menu found with name name, false if not found
*/
function crawl_menu(menu_list, name) {
    var len = array_length(menu_list);
    var ret;
    for (var i = 0; i < len; i++) {
        if menu_list[i].name == name
            return true;
        if !menu_list[i].sub
            return false;
        ret = crawl_menu(menu_list[i].sub, name);
        if is_bool(ret) && ret
            return menu_list[i];
        else if is_array(ret)
            return ret;
    }
    return false;
}
