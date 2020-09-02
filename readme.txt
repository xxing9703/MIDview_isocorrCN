# MIDview_isocorrCN 

MIDview_isocorrCN is an updated version of isocorr13C15N, which added the new functionality of sample grouping, interface for data visualization (MIDs with statistics) and batch export tools for quick views.

see readme.txt in https://github.com/xxing9703/isocorr13C15N for the basic use of natural isotope correction of 13C and 15N labeled data.

# Installation and RUN
   requires Matlab 2018b or later being installed
   Open 'gui_isocorr.m' in matlab and click RUN.  
   Follow instructions on the interface.

# Input file

 ".csv" file directly from Maven or el-Maven output is required.  

 
 # Output file
 
  1. Clicking on Isocorr Button:
     After performing isotope correction, an output file of " XXXX_cor.xlsx" will be automatically saved in the current folder, witch contains 3 tabs:
 -- absolute intensities after correction
 -- relative enrichment after correction
 -- total ion signals after correction

  2. Clicking on Report button:
    Will create a new folder and export multiple figures that contain MID plots for all the metabolites. This feature is very useful for quick overviews and identify metabolites of interest.
     
 # Interactive features
   1. Browse and select metabolite by clicking on the specific row of the input data table, axes on the right will show MID plot.
   2. user's choice to select viewing 1) absolute or relative, 2) before or after correction, 3) integrate along 13C or 15N.
   3. Grouping: user can group samples of replicates by giving them identical grpNames. By default, grpNames of each sample will be the sample name ignoring the strings after the last '_'. for example: 'day1_rep1', 'day1_rep2' will have the same grpName of 'day1'.

 # interface 
<img src="screenshot.png">

  
  
