#import "Basic";
#import "Input";
#import "Window_Creation";
#import "Vulkan"; // we use this instead of "jai/modules"

the_window : Window_Type;
window_width : u32 = 1200;
window_height : u32 = 800;

main :: () {
    the_window = create_window(window_width, window_height, "Hello, Sailor!");

    init_vulkan();
    main_loop();
    clean_up();
}


main_loop :: () {
    quit := false;
    while !quit {
        update_window_events();
        for events_this_frame {
            if it.type == {
                case .QUIT; quit = true;
                case .KEYBOARD;
                    if !it.key_pressed continue;
                    if it.key_code == .ESCAPE then quit = true;
            }
        }

        draw_one_frame();
    }

}

draw_one_frame :: () {

}

init_vulkan :: () {

}

clean_up :: () {

}
