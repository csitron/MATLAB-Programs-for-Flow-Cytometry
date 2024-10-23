function [struct,processed_data,spl_names] = stitch_flow_struct(batchfile,main_channel,gate_matrix,norm_channel,backinds,num_group,num_rep)
%this function: 1) gathers the location of fcs files using flowstitch, 2)
%reads the fcs files into a structure using readFlowDataBatch, then 3)
%processes and reshapes the data using flow_struct_process


%gather the data from where it is stored, then read in the data into
%struct, a structure that hold the raw data
[filepaths,labels] = flowstitch(batchfile);
struct=readFlowDataBatch(filepaths,labels,main_channel,gate_matrix,norm_channel);


%process the data in the structure and remodel into matrices
jump = num_rep*num_group;
expind_1 = length(backinds)+1;
steps = [expind_1:jump:length(struct.L)-(jump-1)];
spl_names = reshape(struct.L(expind_1:num_rep:end),num_group,length(steps))';

%process with or without background subtraction
if isempty(backinds)
    processed_data = flow_struct_process(struct,steps,num_group,num_rep);
else
    processed_data = flow_struct_process(struct,steps,num_group,num_rep,backinds);
end

%plot
channel_no = disp_channels(struct);

bar_error_scatter(struct,processed_data.normalized,...
    processed_data.normalized_err,processed_data.normalized_raw_med,num_rep)
ylabel({[channel_no{main_channel} ' / ' channel_no{norm_channel} ' (Normalized)']})

bar_error_scatter(struct,processed_data.med,...
    processed_data.med_err,processed_data.raw_med,num_rep)
ylabel({[channel_no{main_channel} ' / ' channel_no{norm_channel} ' (Non-normalized)']})

    function bar_error_scatter(struct,averages,errors,raw_data,num_rep)
        averages = reshape(averages', [], 1);
        errors = reshape(errors', [], 1);
        figure
        b = barwitherr(errors,averages)
        hold on
        raw_data = reshape(raw_data', [], 1);
        bar_x_pos = repmat(b.XData,num_rep,1);
        plot(bar_x_pos(:),raw_data,'ko')
        set(gca,'XTick',1:length(struct.L(expind_1:num_rep:end)))
        set(gca,'XTickLabel',struct.L(expind_1:num_rep:end))
        xtickangle(45)
    end
end