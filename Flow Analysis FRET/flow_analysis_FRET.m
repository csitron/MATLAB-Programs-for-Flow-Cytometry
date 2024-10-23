%define variables of interest
ch = 5; %acceptor fluorescence channel
norm = 4; %donor fluorescence channel
gate = [10 2e5; 3 -10e5]; %gate based on channel 10 (FCS-H) over 2e5 and chnnel 3 (SSC-A) under 10e5
backinds = []; %FRET analysis does not require background subtraction - leave empty

%read in the data in the batch file
num_group = 2;
num_rep = 3;
[fret_struct,fret_process,spl_names] = ...
    stitch_flow_struct('batchLLOMeTimingTitration_rep1.m',ch,gate,norm,backinds,num_group,num_rep)

%example of plotting raw data to find a gate based on forward/side scatter
disp_channels(fret_struct)
fsch = 10;
ssca = 3;
figure;plot(fret_struct.D{1}(:,fsch),fret_struct.D{1}(:,ssca),'b.')
hold on;plot(fret_struct.DF{1}(:,fsch),fret_struct.DF{1}(:,ssca),'r.')
xlabel('FSC-H');ylabel('SSC-A');legend({'outside of gate' 'in gate'})

%calculate the overlap between pairs of replicate groups
[overlap_raw_holder,overlap_av_holder,overlap_err_holder] = ...
    FRET_histogram_overlap(fret_struct,num_group,num_rep)

%example of plotting data overlap data
drug_concentration = [0 2000];
figure;errorbar(drug_concentration,overlap_av_holder,overlap_err_holder,'k-')
hold on;plot(repmat(drug_concentration,num_rep,1),overlap_raw_holder,'kO')
xlabel('concentration of LLOMe (uM)');ylabel('percent of FRET positive cells')