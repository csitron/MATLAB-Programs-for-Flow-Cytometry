
function dispwindex(x)
for i=1:length(x)
    str = sprintf([num2str(i), '\t',x{i},'\n']);
    fprintf(str)
end
end