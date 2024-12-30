Flow Cytometry Data Analysis Toolkit for Matlab

Project description:
This package contains a suite of functions that enables facile analysis of flow cytometry data. The first layer of functions read in the data (in .fcs format) and process it to obtain basic summary measurements of fluorescence intensity. There is then a second layer of functions to specifically analyze FRET data and to measure the amount of events inside of a user-defined gate. 

How to install the project:
Outside of the functions supplied in the package and stock Matlab functions, there are two additional dependencies: fca_readfcs by Laszlo Balkay (https://www.mathworks.com/matlabcentral/fileexchange/9608-fca_readfcs) and dscatter by Robert Henson (https://www.mathworks.com/matlabcentral/fileexchange/8430-flow-cytometry-data-reader-and-visualization).
Ensure that each of these functions is in the Matlab path. This code should run on any operating system capable of running Matlab, but has been formally tested on Windows 10. No special hardware is required. If Matlab is already installed, installing the package should take less than 5 min. The code has been tested on Matlab R2020b and R2021b.

Reading in the data and taking simple statistics:
To organize your data, first make two files in the directory where your .fcs files are located: “fileindex.m” and “nameindex.m.” “fileindex.m” should contain a list of filenames with a newline separating each filename. “nameindex.m” should contain a user-defined list of names corresponding to the files in “fileindex.m.” Do not repeat any names.
To select the files you would like to analyze and in which order, make a batchfile (.m format). Each line of the batchfile should have two components, separated by a comma: 1) the location of the directory where the .fcs file is located (simply “.” if the files are in the current directory) and 2) the name of the file of interest as specified in “nameindex.m.” There are three things to keep in mind. First, the statistics rely on having the same number of replicates for each sample (>1). If you do not have multiple replicates or an uneven number of replicates between samples, you can repeat the sample in the batchfile. Second, the code allows for the opportunity to normalize within groups (e.g. treatment conditions). The sample within the group that will be normalized to should be in the last position. For instance, if you have a treatment group with DMSO, drug X, and drug Y, you could normalize to the value obtained in DMSO by putting DMSO in the third position. Third, if using background controls (e.g. non-fluorescent), place those (as many samples as you’d like) at the top of the batchfile. 
Read in the data using the function stitch_flow_struct, which takes the following arguments:

batchfile = the .m file specifying the samples of interest, described above 
main_channel = the number of the channel you would like to analyze in the simple statistics. If you are unsure about the layout of the fcs file, you can simply run the code and use the disp_channels function on the struct that is returned. 
gate_matrix = a numeric matrix containing the channels and values you would like to gate your cells based on with the following format [channel_number1 lowervalue;channel_number2 -uppervalue…]. You can supply as many channel + value pairs as you would like. To select cells above a value, ensure the value has a positive sign, and place a negative sign below the value to specify that would like to analyze the events below that 
norm_channel = the number of the channel your analysis will be normalized against in the simple statistics
backinds = a matrix containing the indices (i.e. rows) of the batchfile corresponding to non-fluorescent samples used for background subtraction. If none are used, leave empty.
num_group = the number of types of samples in a group. For the example above of drug X, drug Y, and DMSO, num_group = 3. 
num_rep = the number of replicates for each sample. See “batchRNFDoxRep1.m” for an example of a batchfile with groups of 5 samples, for a total of two groups.

Running this code will return three things:
1. a struct containing the data read from each of the fcs files, stored in fields:
struct.M = log2 mean values of norm_channel-normalized main_channel fluorescence
struct.MD = log2 median values of norm_channel-normalized main_channel fluorescence
struct.RM = mean values of norm_channel-normalized main_channel fluorescence
struct.RMD = median values of norm_channel-normalized main_channel fluorescence
struct.SD = standard deviation of  log2 norm_channel-normalized main_channel fluorescence
struct.D = a cell containing matrices of the raw data
struct.DF = a cell containing matrices of the gated raw data
struct.L = sample labels (specified in nameindex.m)
struct.params = parameters taken from the header of the fcs file
struct.B = a pre-defined matrix to define histogram bins (see below)
struct.H = a matrix containing histogram frequency values for norm_channel-normalized main_channel fluorescence according to the bins in struct.B
2. A processed_data structure containg the background-subtracted, processed data from struct:
processed_data.med = averaged values from the group of samples in struct.RMD (arranged as shown by sample labels in spl_names.
processed_data.med_err = error values corresponding to processed_data.med
processed_data.raw_med = background-subtracted values from struct.RMD, rearranged so replicates are adjacent to each other in each row, and that the rows correspond to different groups.

processed_data.normalized = equivalent to processed_data.med with normalization to the last sample in the group such that the last sample equals 1.
processed_data.normalized_err = error values corresponding to processed_data.normalized
processed_data.normalized_raw_med = equivalent to processed_data.raw_med with normalization to the last sample in the group such that the average of the last sample equals 1.
3. A spl_names cell that contains the sample names specified in struct.L, rearranged to reflect the order of samples in processed_data.med, .med_err, .normalized, and .normalized_err.
For an example on how to run this segment of the code, see flow_analysis_Intensity.m. Running this code should take less than 1 min on a "normal" desktop computer.

Calculating the percentage of FRET-positive cells
To analyze the percentage of FRET-positive cells, you first need to read in a batchfile using stitch_flow_struct as described above. This batchfile should have num_group = 2, such that the FRET-negative control is in the first position and the experimental condition is in the second position. This negative control samples need to be repeated in the batchfile for each experimental condition. See “batchLLOMeTimingTitration_rep1.m” for an example where num_group = 2 and num_rep = 3. The main_channel needs to be the FRET acceptor channel and the norm_channel needs to be the FRET donor channel.

Then run the function FRET_histogram_overlap, which takes the following arguments:
fret_struct = the struct returned by stitch_flow_struct.
num_group and num_rep are described above.

Running the code will then return three things:
1.  An overlap_raw_holder matrix containing the values for how the percentage of cells in the experimental condition Acceptor/Donor fluorescence histogram are right-shifted relative to the FRET-negative control. Columns correspond to the control-experimental condition pairs in the batchfile and rows correspond to replicates.
2. An overlap_av_holder matrix, which is the average of the replicates in the overlap_raw_holder matrix.
3. An overlap_err_holder matrix, which is the standard error of the mean for the replicates in the overlap_raw_holder matrix.
An example of this type of analysis can be found in flow_analysis_FRET.m.

Calculating the percentage of cells in a self-drawn gate:
To calculate the percentage of cells inside of a gate, first run stitch_flow_struct as described above. Keep in mind that the groups need to be arranged such that the non-fluorescent control is in the first position and all experimental conditions come after. The main_channel should be your fluorescent channel of interest. To correct for autofluorescence, we find that the analysis works best if the norm_channel is an adjacent channel (i.e. same laser but different filter).
Then run the function calculate_in_gate, which takes the following arguments:
 gate_struct = the struct returned by stitch_flow_struct
autofluorescence_ch = the norm_channel used in stitch_flow_struct (i.e. channel adjacent to fluorescent channel)
main_ch = the main_channel used in stitch_flow_struct (i.e. the fluorescent channel of interest)
num_rep = the number of replicates
axis_bounds =  the bounds on the plot [x min x max y min y max] that you would like to use to raw the gate on your samples. This needs to be found empirically.
roof_main_ch_max = this will put a “roof” on the max y values of a triangular gate, so that the gate can be extended all the way to the maximum value possible in the flow cytometer, without actually needing to have the gate drawing plot unnecessarily compressed when viewing both the control scatter plot and the maximum.
This will prompt you to draw a gate on a scatter plot of the control non-fluorescent sample. The code will then return the following:
percentage_in_gate = the percentage of cells inside the gate you drew for each sample, with each column representing a given condition (position number given by the batchfile) and the rows representing replicates
gate = the bounds of the gate you drew
An example of this type of analysis can be found in flow_analysis_Gate.m.

Acknowledgments:
We acknowledge Prof. Onn Brandman (Stanford University) for writing the original version of the readFlowDataBatch function, Laszlo Balkay for the fca_readfcs function, and Robert Henson for the dscatter function. This work was supported by the joint efforts of The Michael J. Fox Foundation for Parkinson’s Research (MJFF) and the Aligning Science Across Parkinson’s (ASAP) initiative. MJFF administers the grants ASAP-000282 and ASAP- 024268 on behalf of ASAP and itself.


