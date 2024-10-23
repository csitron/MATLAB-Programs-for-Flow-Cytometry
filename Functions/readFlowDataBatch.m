function R=readFlowDataBatch(filePaths,labels,C,LIMIT,SSN)

i=1;
for i=1:length(filePaths)
    [D{i},params]=fca_readfcs(filePaths{i});
end

B=-20:.5:37;

for i=1:length(C)
    [M(:,i),H(:,:,i),DOUT,MD(:,i),NUM(:,i),SD(:,i),RM(:,i),RMD(:,i)]=xx(D,C(i),B,SSN,LIMIT);
end
R.B=B;
R.M=M;
R.H=H;
R.L=labels;
R.DF=DOUT;
R.D=D;
R.params=params;
R.MD=MD;
R.NUM=NUM;
R.SD=SD;
R.RM=RM;
R.RMD=RMD;

function [m,h,D,MD,NUM,SD,RM,RMD]=xx(D,I,B,SSN,LIMIT)
for i=1:length(D)
    l=ones(size(D{i}(:,1)))==1;
    if (length(LIMIT)>1)        
        for j=1:size(LIMIT,1)
            if (LIMIT(j,2)>0)
                l=l&((D{i}(:,LIMIT(j,1)))>LIMIT(j,2));
            else
                l=l&((D{i}(:,LIMIT(j,1)))<-LIMIT(j,2));
            end                
        end
    end
    if SSN>0
        v=D{i}(l,I)./D{i}(l,SSN);
    else
        v=D{i}(l,I);
    end
    v=v(v>0);
    v=v(isfinite(v));
    vraw = v;
    v=log2(v);
    h(:,i)=hist(v,B);
    h(:,i)=h(:,i)/sum(h(:,i));
    m(i)=mean(v);
    MD(i)=median(v);
    NUM(i)=length(v);
    SD(i)=std(v);
    RM(i) = mean(vraw);
    RMD(i) = median(vraw);
    D{i}=D{i}(l,:);
end