## Scripts

*This directory contains scripts for the project "Assessing population structure of Pacific cod through an ecological and evolutionary perspective"*

<br>
### R Scripts used for Final Analysis
`multivariate_normal_test_ochem_linux`: exploratory analysis of raw otolith microchemistry data, to explore multivariate normality of the data set. 
<br>
`project_script0_relativize_dist`: code for loading and relativizing data, and generating Euclidean distance matrices. Must be run before all other scripts to conduct analysis. 
<br>
`project_script1_perm_anova_desktop`: run PERMANOVAs and one-way ANOVAs
<br>
`project_script2_NMDS_core_desktop`: generate and plot NMDS ordination for otolith core data
<br>
`project_script2_NMDS_edge_desktop`: generate and plot NMDS ordination for otolith edge data
<br>
`project_script3_Mantel`: Conduct Mantel tests
<br>
`project_script4_cluster_desktop`: conduct hierarchical clustering analysis on otolith edge and core data. explores three methods of clustering, then uses Ward method to produce final analysis and dendrograms.
<br>
`project_script5_cluster_NMDS_desktop`: Visualization. Plot cluster analysis over NMDS for otolith and core data.
<br>
`project_script6_gen_NMDS`: Visualization. Plot NMDS ordination for otolith core, then overlay genetic assignment from Structure.
<br>
`project_script7_cluster_compare`: Visualization. Create tanglegrams to compare cluster analysis of otolith core and microchemistry data.
<br>
`project_script8_mapping`: Visualization. Generate map of sampling sites. 
<br>
`mapping_functions`: Contains functions sourced for mapping, script 8. 




<br>
<br>
### Extra code of interest
`project_script6_heatmap_gen`: Plot dendrogram of otolith core data with heatmap of genetic assignment. Note that colors corresponding to dendrogram branches could not be coerced to match sampling site legend. 
<br>
`project_script4_kmeans_desktop`: Conduct Kmeans clustering on otolith core and edge microchemistry data. Was used to see if kmeans clustering produced more intuitive clusters (based on NMDS). Not used for final paper, as clusters identified were similar to hierarchical cluster analysis. 
