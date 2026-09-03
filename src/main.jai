#import "Basic";
#import "Input";
#import "SDL";

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

// ----------------------------------------------------------------------------: Vulkan

init_vulkan :: () {
    create_instance();
}

// ----------------------------------------------------------------------------: Instance

instance : VkInstance;

// NOTE: The instance is the connection between your application and the Vulkan
// module and creating it involves specifying some details about your application
// to the driver.
create_instance :: () {
    optional_extensions: [..] string;
    array_add(*optional_extensions, VK_KHR_SURFACE_EXTENSION_NAME);
    array_add(*optional_extensions, "VK_KHR_win32_surface");
    array_add(*optional_extensions, "VK_KHR_wayland_surface");
    array_add(*optional_extensions, "VK_EXT_metal_surface");
    array_add(*optional_extensions, "VK_KHR_xlib_surface");

    // find extensions
    enabled_extensions : [..] *u8;
    #if OS == .MACOS {
        // Portability enumeration is requred for MoltenVK.
        array_add(*enable_extensions, VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME);
    }

    {
        count: u32;
        vkEnumerateInstanceExtensionProperties(null, *count, null);

        available_extensions: [..] VkExtensionProperties;
        array_resize(*available_extensions, count);

        vkEnumerateInstanceExtensionProperties(null, *count, available_extensions.data);

        for optional : optional_extensions {
            for available : available_extensions {
                if optional == to_string(available.extensionName) {
                    array_add(*enabled_extensions, optional.data);
                    break available;
                }
            }
        }
    }

    // Just provice some information about our application.
    app_info := VkApplicationInfo.{
        pApplicationName   = "Vulkan Example",
        pEngineName        = "Poison QIEKN",
        applicationVersion = VK_MAKE_VERSION(1, 0, 0),
        engineVersion      = VK_MAKE_VERSION(1, 0, 0),
        apiVersion         = VK_API_VERSION_1_3,
    };

    create_info := VkInstanceCreateInfo.{
        pApplicationInfo = *app_info,
        enabledExtensionCount = enabled_extensions.count.(u32),
        ppEnabledExtensionNames = enabled_extensions.data,
    };

    result := vkCreateInstance(*create_info, null, *instance);
    assert(result == .SUCCESS);
}

// ----------------------------------------------------------------------------: Clean up

clean_up :: () {
    vkDestroyInstance(instance, null);
}
