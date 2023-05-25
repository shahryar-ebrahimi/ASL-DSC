# ASL-DSC
A matlab code for Arterian Spin Labeling (ASL) and Dynamic Susceptibility Contrast (DSC) fMRI dataset.

This code generates a map of actiavted regions on brain: 

we aim to overlay the MAP correlation obtained in the code onto the initial brain tissue image in order to extract regions with high correlation. 
To do this, we first take the average of the 144 frames we have to obtain a structural image of the brain, although it is a functional image. 
To represent the correlated regions, we use the RGB format, where positively correlated regions are displayed in red and negatively correlated regions in blue.

By comparing the two available images (one resulting from correlation and the other from averaging), 
we will mark the pixels in the averaged image that have the highest positive correlation values in the correlation image as red. 
Similarly, we will mark the pixels with the highest negative correlation values as blue. 
It should be noted that a threshold value of 0.6 has been considered. 
This threshold indicates that pixels will only be identified if their correlation value is at least 60% of the maximum correlation value. 
Other values will not be considered. Naturally, decreasing this threshold will result in more activated regions in the final image.
