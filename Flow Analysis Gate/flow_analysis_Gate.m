%channels
close all
main_ch = 4; %this is the channel in which fluorescence will be assessed
autofluorescence_ch = 5; %control for autofluorescence by comparing with a 
gate = [8 2*10^5;3 -10*10^5]; %gate out small/large material based on channel 8 (FCS-H) over 2e5 and channel 10 (SSC-A) under 10e5
backinds = []; %defines the samples that are non-fluorescent controls, can leave empty if no such samples are measured

%this reads in the flow data
num_group = 3; 
num_rep = 2; 
[gate_struct,gate_struct_processed,spl_names] = ...
    stitch_flow_struct('batchLipo_rep3.m',main_ch,gate,autofluorescence_ch,backinds,num_group,num_rep)

%this is the module that will allow to draw a gate and calculate the cells
%in that gate
axis_bounds = [-0.025*10^5 2.5*10^5 -0.025*10^5 3*10^5]; %[x-min x-max y-min y-max bounds for drawing gate]
roof_main_ch_max = [1048575];%optional argument, extends the upper part of the gate to this max value
[percentage_in_gate,gate] = calculate_in_gate(gate_struct,autofluorescence_ch,main_ch,num_rep,axis_bounds,roof_main_ch_max)