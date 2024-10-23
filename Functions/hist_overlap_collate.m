function [overlap,overlap_av,overlap_err] = hist_overlap_collate(data,leading_hist_inds,lagging_hist_inds)
%this function calculates the percentage of the leading FRET histogram that
%is non-overlapping with the lagging FRET histogram

y1 = mean(data.H(:,lagging_hist_inds,1)')';
[~,max1ind] = max(y1);

overlap = [];
for i = 1:length(leading_hist_inds)
    y2 = data.H(:,leading_hist_inds(i),1);
    yd = y2 - y1;
    
    neg = yd(1:max1ind);
    pos = yd(max1ind:end);
    
    sum_neg = -sum(neg(neg>0));
    sum_pos = sum(pos(pos>0));
    
    overlap(i) = (sum_neg + sum_pos)*100;

    
    if abs(sum_neg) > sum_pos
        disp(['found negative on index ' num2str(leading_hist_inds(i))])
    end 
    
end

overlap_av = mean(overlap);
overlap_err = std(overlap)/sqrt(length(overlap));

end
