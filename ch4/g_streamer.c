#include <gst/gst.h>
#include <stdio.h>
#include <stdlib.h>

GstElement *pipeline, *source, *convert, *filter, *sink;
GMainLoop *main_loop;

static gboolean handle_bus_messages(GstBus *bus, GstMessage *msg, gpointer data) {
    switch (GST_MESSAGE_TYPE(msg)) {
        case GST_MESSAGE_ERROR: {
            GError *err;
            gchar *debug_info;
            gst_message_parse_error(msg, &err, &debug_info);
            g_printerr("ERROR: %s\n", err->message);
            g_free(debug_info);
            g_error_free(err);
            g_main_loop_quit(main_loop);
            break;
        }
        case GST_MESSAGE_EOS:
            g_print("End of stream.\n");
            g_main_loop_quit(main_loop);
            break;
        default:
            break;
    }
    return TRUE;
}

gboolean setup_pipeline(const char *device, const char *output_file, int width, int height) {
    GstCaps *caps;

    source  = gst_element_factory_make("v4l2src", "source");
    convert = gst_element_factory_make("videoconvert", "convert");
    filter  = gst_element_factory_make("capsfilter", "filter");
    sink    = gst_element_factory_make("filesink", "sink");

    if (!source || !convert || !filter || !sink) {
        g_printerr("Failed to create one or more elements.\n");
        return FALSE;
    }

    g_object_set(source, "device", device, NULL);
    g_object_set(sink, "location", output_file, NULL);

    gchar *caps_str = g_strdup_printf("video/x-raw, format=I420, width=%d, height=%d", width, height);
    caps = gst_caps_from_string(caps_str);
    g_object_set(filter, "caps", caps, NULL);
    g_free(caps_str);
    gst_caps_unref(caps);

    pipeline = gst_pipeline_new("yuv-pipeline");
    if (!pipeline) {
        g_printerr("Failed to create pipeline.\n");
        return FALSE;
    }

    gst_bin_add_many(GST_BIN(pipeline), source, convert, filter, sink, NULL);
    if (!gst_element_link_many(source, convert, filter, sink, NULL)) {
        g_printerr("Failed to link elements.\n");
        return FALSE;
    }

    return TRUE;
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        g_printerr("Usage: %s <device> <output.yuv> <width> <height>\n", argv[0]);
        return -1;
    }

    const char *device = argv[1];
    const char *output_file = argv[2];
    int width = atoi(argv[3]);
    int height = atoi(argv[4]);

    gst_init(&argc, &argv);

    if (!setup_pipeline(device, output_file, width, height)) {
        g_printerr("Pipeline setup failed.\n");
        return -1;
    }

    main_loop = g_main_loop_new(NULL, FALSE);
    GstBus *bus = gst_element_get_bus(pipeline);
    gst_bus_add_watch(bus, handle_bus_messages, NULL);

    gst_element_set_state(pipeline, GST_STATE_PLAYING);
    g_print("Capturing from %s at %dx%d → %s\n", device, width, height, output_file);

    g_main_loop_run(main_loop);

    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(bus);
    gst_object_unref(pipeline);
    g_main_loop_unref(main_loop);

    g_print("Done.\n");
    return 0;
}
