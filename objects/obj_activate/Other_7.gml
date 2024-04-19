/// @description Set the start or end animation after or before activation

// After deactivation revert back to begin animation
if sprite_index == spr_trans_reversed && !interacted_with {
    sprite_index = spr_begin;
}
// After activation set to the activated animation
else if sprite_index == spr_trans && interacted_with {
    sprite_index = spr_end;
}
