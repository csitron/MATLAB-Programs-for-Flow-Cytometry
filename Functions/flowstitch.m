function [filePaths,labels] = flowstitch(batchlist)
[dirName,labels] = textread(batchlist,'%s%s','delimiter',',');
for i =1:length(dirName)
    fileindex=textread([dirName{i} '/fileindex.m'],'%s','delimiter','\n');
    nameindex=textread([dirName{i} '/nameindex.m'],'%s','delimiter','\n');
    thisIndex=findgrep_exact(nameindex,labels{i});
    if (length(thisIndex)~=1)
        disp(i)
        disp('error')
        if (length(thisIndex)>1)
            disp('too many found')
        end       
        thisFile='nofile';
    else
        thisFile=fileindex{thisIndex};
    end
    filePaths{i}=[dirName{i} '/' thisFile];
end