%channels
%1 'Time'
%2 'FSC-A'
%3 'SSC-A'
%4 'BL1-A'
%5 'YL2-A'
%6 'YL1-A'
%7 'VL1-A'
%8 'FSC-H'
%9 'SSC-H'
%10 'BL1-H'
%11 'YL2-H'
%12 'YL1-H'
%13 'VL1-H'
%14 'FSC-W'
%15 'SSC-W'
%16 'BL1-W'
%17 'YL2-W'
%18 'YL1-W'
%19 'VL1-W'

close all

ch = 4;

filter2 = [7 1000; 5 exp(6)];
filter3 = [3 2*10^5;8 -10 * 10^5];


norm = 5;
back = 0;
here = pwd;
backinds1 = [];

%rep1
num_bg5 = 5;
num_rep3 = 3;
[x1,x1_back,x1_sub] = ...
    stitch_flow_struct('batchRNFDoxRep1.m',ch,filter3,norm,backinds1,num_bg5,num_rep3)
