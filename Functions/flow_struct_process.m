function processed_data = flow_struct_process(struct,steps,num_group,num_rep,backinds)
%this function processes the data read in from readFlowDataBatch and
%remodels the data into matrices where the median values of the replicates are grouped next to
%each other, calculates the average and SEM of those values, then
%normalizes to the last condition in each group and additionally calculates
%the average and SEM of this normalized data as well

processed_data=struct;

jump = num_group*num_rep;

%make matrices of raw medians
raw_med = [];
j=0;
for i = steps
    j=j+1;
    raw_med(j,:) = struct.RMD([i:i+(jump-1)],1);
end

%substract out the background, if desired
if nargin == 5
    bgval = mean(struct.RMD([backinds],1));
    raw_med = raw_med - bgval;
end

%calculate medians and error
med_err = zeros(rows(raw_med),num_group);
med = med_err;
for i=1:rows(raw_med)
    sub_err = [];
    sub_med = [];
    for k = 1:num_rep:jump-1
        sub_err(end+1) = std(raw_med(i,k:k+(num_rep-1)))/sqrt(num_rep);
        sub_med(end+1) = mean(raw_med(i,k:k+(num_rep-1)));
    end
    med_err(i,:) = sub_err;
    med(i,:) = sub_med;
end

%normalize to the last sample in the group
norm_condition = raw_med(:,jump-(num_rep-1):jump);
norm_condition_av = mean(norm_condition,2);
normalized_raw_med = [];
for i = 1:rows(raw_med)
    normalized_raw_med(i,:) = raw_med(i,:) ./ norm_condition_av(i,:);
end

%calculate the averages of the medians from the normalized data
normalized_err = zeros(rows(raw_med),num_group);
normalized = normalized_err;
for i=1:rows(normalized_raw_med)
    sub_err = [];
    sub_med = [];
    for k = 1:num_rep:jump-1
        sub_err(end+1) = std(normalized_raw_med(i,k:k+(num_rep-1)))/sqrt(num_rep);
        sub_med(end+1) = mean(normalized_raw_med(i,k:k+(num_rep-1)));
    end
    normalized_err(i,:) = sub_err;
    normalized(i,:) = sub_med;
end

%store the data in the processed data structure
processed_data.med_err = med_err;
processed_data.med = med;
processed_data.raw_med = raw_med;
processed_data.normalized_raw_med = normalized_raw_med;
processed_data.normalized = normalized;
processed_data.normalized_err = normalized_err;

end