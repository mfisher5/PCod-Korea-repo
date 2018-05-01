##function to convert default burrows output to cleaner smaller version for input to R
##Wes Larson
## 4/30/14
##wlarson1@uw.edu
#
## Edited 4/30/2018 by Mary Fisher to take command line arguments
######################################################################################

import sys

import re
def dirty_to_clean_r2_distr(r2_dirty_file):
  with open(r2_dirty_file, "r") as dirty_R2:
      clean_r2_filename="clean_{}".format(r2_dirty_file)
      clean_r2_file=open(clean_r2_filename, "w")
      title_string="locus1\tlocus2\tsamp_size\tMean_r2\tr2_drift\n"
      clean_r2_file.write(title_string)
      for line in dirty_R2:
        line = line.strip()
        if re.match(r'[0-9]+,',line): #starts with num
          split_r2_line=line.split()
          locus1=re.sub(",","",split_r2_line[0])
          locus2=split_r2_line[1]
          samp_size=split_r2_line[5]
          mean_r2=split_r2_line[8]
          r2_drift=split_r2_line[9]
          combo_line=locus1+"\t"+locus2+"\t"+samp_size+"\t"+mean_r2+"\t"+r2_drift+"\n"
          clean_r2_file.write(combo_line)
  clean_r2_file.close()
  
dirty_to_clean_r2_distr(sys.argv[1])
