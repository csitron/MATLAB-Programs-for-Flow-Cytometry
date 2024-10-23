%define global variables
ch = 4; %channel of interest
norm = 5; %reference channel for normalization
gate = [8 2e5;3 -10e5]; %gate based on channel 3 (FCS-H) over 2e5 and channel 8 (SSC-A) under 10e5
backinds1 = []; %no background subtraction

%rep1
num_group = 3;
num_rep = 2;
[intensity_struct,processed_intensity,spl_names] = ...
    stitch_flow_struct('batchRNFDoxRep1.m',ch,gate,norm,backinds1,num_group,num_rep)


%example of plotting raw data to find a gate based on forward/side scatter
disp_channels(intensity_struct)
ssca = 3;
fsch = 8;
figure;plot(intensity_struct.D{1}(:,fsch),intensity_struct.D{1}(:,ssca),'b.')
hold on;plot(intensity_struct.DF{1}(:,fsch),intensity_struct.DF{1}(:,ssca),'r.')
xlabel('FSC-H');ylabel('SSC-A');legend({'outside of gate' 'in gate'})