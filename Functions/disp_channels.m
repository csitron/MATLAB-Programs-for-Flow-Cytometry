function channels = disp_channels(struct)
%this function displays the indices for each fluorescence channel,
%corresponding to a column in the fcs file, taking the flow cytometry structure created by the
%function stitch_flow_struct
str = ['struct.params.par.name'];
display = evalc(str);
split_display = strsplit(display,'ans =');
for i = 2:length(split_display)
    split_display{i} = strrep(split_display{i}, '''', '');
end
dispwindex(split_display(2:end)')
channels = split_display(2:end);
end