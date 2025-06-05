# Set metadata for the component
set_module_property NAME esl_bus_demo_example
set_module_property VERSION 1.0
set_module_property GROUP "EncoderIntegration"
set_module_property DESCRIPTION "Encoder IP integration for DE10-Nano"
set_module_property AUTHOR "CyberGang"

# Add HDL source file
add_file Encoder.v {SYNTHESIS SIMULATION}

# Define system interfaces
add_interface clk clk end
add_interface_port clk clk clk Input 1

add_interface reset reset end
add_interface_port reset reset_reset_n reset_n Input 1

# Define encoder input interfaces
add_interface encoder_a conduit end
set_interface_property encoder_a EXPORT_OF encoder_a_export
add_interface_port encoder_a encoder_a_export Input 1

add_interface encoder_b conduit end
set_interface_property encoder_b EXPORT_OF encoder_b_export
add_interface_port encoder_b encoder_b_export Input 1

# Define encoder output interface
add_interface encoder_counter conduit end
set_interface_property encoder_counter EXPORT_OF encoder_counter_export
add_interface_port encoder_counter encoder_counter_export Output 32

