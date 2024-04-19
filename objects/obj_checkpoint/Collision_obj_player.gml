/// @description Behaviour when player is at the checkpoint

if !already_used {
    already_used = true;
    construct_last_checkpoint(x, bbox_bottom);
    checkpoint_to_save();
    save_to_file();
}
