/// @description Draw the pause menu

if global.pause {
    y_offset = draw_pause_bkg(bkg_spr_width, bkg_width_scale, bkg_height_scale, bkg_left_off, bkg_top_off, global.current_menu.name);
    draw_sub_menu(global.current_menu.sub, item_gap, bkg_left_off, y_offset);
}
