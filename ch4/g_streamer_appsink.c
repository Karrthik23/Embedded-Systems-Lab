#include <gst/gst.h>
#include <gst/app/gstappsink.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

GstElement *pipeline, *source, *convert, *filter, *appsink;
GMainLoop *main_loop = NULL;
FILE *output_file = NULL;

// Handle Ctrl+C to stop the main loop
void handle_sigint(int sig) {
    if (main_loop) {
        g_main_loop_quit(main_loop);
    }
}

// Callback function for each new frame
GstFlowReturn on_new_sample(GstAppSink *sink, gpointer user_data) {
    GstSample *sample = gst_app_sink_pull_sample(sink);
    if (!sample) return GST_FLOW_ERROR;

    GstBuffer *buffer = gst_sample_get_buffer(sample);
    GstMapInfo map;

    if (gst_buffer_map(buffer, &map, GST_MAP_READ)) {
        // Write raw YUV data to the output file
        fwrite(map.data, 1, map.size, output_file);
        fflush(output_file);  // ensure data is written immediately
        g_print("Wrote frame: %zu bytes\n", map.size);
        gst_buffer_unmap(buffer, &map);
    }

    gst_sample_unref(sample);
    return GST_FLOW_OK;
}

// Create and link the pipeline
gboolean setup_pipeline(const char *device, int width, int height) {
    GstCaps *caps;

    source  = gst_element_factory_make("v4l2src", "source");
    convert = gst_element_factory_make("videoconvert", "convert");
    filter  = gst_element_factory_make("capsfilter", "filter");
    appsink = gst_element_factory_make("appsink", "sink");

    if (!source || !convert || !filter || !appsink) {
        g_printerr("Failed to create GStreamer elements.\n");
        return FALSE;
    }

    g_object_set(source, "device", device, NULL);

    gchar *caps_str = g_strdup_printf("video/x-raw, format=I420, width=%d, height=%d", width, height);
    caps = gst_caps_from_string(caps_str);
    g_object_set(filter, "caps", caps, NULL);
    g_free(caps_str);
    gst_caps_unref(caps);

    // Set up appsink
    g_object_set(appsink, "emit-signals", TRUE, "sync", FALSE, NULL);
    g_signal_connect(appsink, "new-sample", G_CALLBACK(on_new_sample), NULL);

    pipeline = gst_pipeline_new("appsink-pipeline");
    if (!pipeline) {
        g_printerr("Failed to create pipeline.\n");
        return FALSE;
    }

    gst_bin_add_many(GST_BIN(pipeline), source, convert, filter, appsink, NULL);
    if (!gst_element_link_many(source, convert, filter, appsink, NULL)) {
        g_printerr("Failed to link pipeline elements.\n");
        return FALSE;
    }

    return TRUE;
}

int main(int argc, char *argv[]) {
    if (argc != 4) {
        g_printerr("Usage: %s <device> <width> <height> <duration_sec>\n", argv[0]);
        return -1;
    }

    const char *device = argv[1];
    int width = atoi(argv[2]);
    int height = atoi(argv[3]);
    

    signal(SIGINT, handle_sigint);
    gst_init(&argc, &argv);

    // Open output file
    output_file = fopen("frames_output.yuv", "wb");
    if (!output_file) {
        g_printerr("Failed to open output file for writing.\n");
        return -1;
    }

    // Set up pipeline
    if (!setup_pipeline(device, width, height)) {
        g_printerr("Pipeline setup failed.\n");
        fclose(output_file);
        return -1;
    }

    // Run pipeline
    main_loop = g_main_loop_new(NULL, FALSE);
    gst_element_set_state(pipeline, GST_STATE_PLAYING);

    g_print("Capturing from %s at %dx%d. Saving to frames_output.yuv\n", device, width, height);
    g_print("Press Ctrl+C to stop...\n");

    // Stop after fixed duration
    // g_timeout_add_seconds(duration, (GSourceFunc)g_main_loop_quit, main_loop);
    g_main_loop_run(main_loop);

    // Cleanup
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);
    g_main_loop_unref(main_loop);

    if (output_file) {
        fclose(output_file);
        g_print("Output file closed.\n");
    }

    g_print("Capture finished.\n");
    return 0;
}
