/// @description Cleanup surfaces and buffers

// Free the surface if it exists
if surface_exists(global.pause_surface)
    surface_free(global.pause_surface);

// Free the buffer if it exists
if buffer_exists(global.pause_surface_buffer)
    buffer_delete(global.pause_surface_buffer);
