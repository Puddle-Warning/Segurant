/// @description Draw the player's GUI for debugging

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_colour(c_red);
draw_text_transformed(10, 10, "HP " + string(hp), 2, 2, 0);

draw_set_colour(c_black);
draw_text_transformed(10, 50, "Stamina " + string(cur_stamina), 2, 2, 0);

if knockedback
    draw_text_transformed(10, 130, "Knocked back", 2, 2, 0);
if invincible
    draw_text_transformed(10, 90, "Invincible", 2, 2, 0);

draw_set_colour(c_white);
