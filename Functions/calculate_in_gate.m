function [percentage_in_gate,gate] = calculate_in_gate(struct,x_ch,y_ch,num_rep,axis_bounds,roof)
%this function allows you to draw a flow cytometry gate and analyze the percentage of cells within
%the gate, using the first sample as a reference to make a scatter
%plot (bounds defined by axis_bounds) of fluorescence values (y_ch vs x_ch) from a flow cytometry struct
%created in stitch_flow_struct. the optional arrgument roof allows you to
%extend the upper portion of the gate, in case you would like to define
%axis bounds that cannot caputure all of the data along the y_ch axis



%draw gate using the first sample
gate_x = struct.DF{1}(:,x_ch);
gate_y = struct.DF{1}(:,y_ch);
fh = figure();
fh.WindowState = 'maximized';
plot(gate_x,gate_y,'r.')
axis(axis_bounds)
title({'draw gate and double click to finish';'start near origin, then right, up, left, and back to origin'})
h=drawpolygon %double click to finish
bound = [h.Position(:,1),h.Position(:,2)];
gate = bound;

%if desired, extend gate upwards to the "roof" value
%assumes gate is drawn starting near origin, then extending right, up, left, then returning to the origin 
if nargin > 5 && ~isempty(roof)
    [east_val,east_ind] = max(gate(:,1));
    insert_roof =  [east_val roof;gate(east_ind+1,1) roof;gate(east_ind+1:end,:)]; 
    gate = [gate(1:east_ind,:);insert_roof];
    
    axis_bounds(end) = roof;
end



%calculate the percentage in the gate for each sample
gated_perc = [];
for i = 1:length(struct.L)
    x_query = struct.DF{i}(:,x_ch);
    y_query = struct.DF{i}(:,y_ch);
    figure;dscatter(x_query,y_query);hold on
    
  
    gate_vis = [gate;gate(1,:)];
    plot(gate_vis(:,1),gate_vis(:,2),'Color',[0 .5 .1])
    axis(axis_bounds)
    title(struct.L{i})
    
    [in,on] = inpolygon(x_query,y_query,bound(:,1),bound(:,2));
    gated = length(in(in==1)) + length(on(on==1));
    gated_perc(i) = gated/length(x_query)*100;
end

%plot the percent in gates
num_cond = length(gated_perc')/num_rep;
percentage_in_gate = reshape(gated_perc,num_rep,num_cond);
means = mean(percentage_in_gate);
figure;bar(means)
bar_pos = repmat((1:num_cond)', 1, num_rep)';
hold on;plot(bar_pos(:),percentage_in_gate(:),'ko')
set(gca,'XTick',1:length(struct.L(1:num_rep:end)))
set(gca,'XTickLabel',struct.L(1:num_rep:end))
xtickangle(45)
ylabel('Percentage of Cells in Gate')
end