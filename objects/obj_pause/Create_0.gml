/// @description Create pause-related variables

draw_set_font(fnt_pause);
font_size = font_get_size(draw_get_font());

global.pause = false;
global.pause_surface = -1;
global.pause_surface_buffer = -1;

bkg_width = 350;
bkg_height = 300;
bkg_spr_width = sprite_get_width(spr_pause_bkg);
bkg_width_scale = floor(bkg_width / bkg_spr_width);
bkg_height_scale = floor(bkg_height / sprite_get_height(spr_pause_bkg));
bkg_top_off = floor( (global.window_height - bkg_height) / 2 ) ;
bkg_left_off = floor( (global.window_width - bkg_width) / 6 ) ;

clr_unselected = c_white;
clr_selected = c_yellow;

item_gap = 30;
y_offset = 0;

global.current_menu = global.pause_menu;

cursor = 0;
