# Animated_Figures
Code for creating animated data visualizations in the form of GIFs.

## General Overview
![Alt Text](https://alexduman.weebly.com/uploads/1/1/0/6/110678391/run-forced-rotation_orig.gif)
This is where I share my code to help animate data visualizations to create figures as GIFs (like the above GIF). If you want to add animation to your figures and data visualizations please feel free to download this repository and modify the code to fit the structure and needs of your data.

In this repository there are two languages that allow you to animate figures. The first one I put together in MATLAB while I was a student at UC Irvine with the help of [Monica Daley, Ph.D.](https://neuromechanics.bio.uci.edu/), and eventually I created a similar script in Python to accommodate anyone without access to MATLAB (including myself following graduation).

## Example Data Description
In the 'data' folder you will find a video file 'Run_Forced_Rotation.mp4' and a corresponding csv file 'Run_Forced_Rotation_EMG.csv'. This is data from a single 30 second trial of a subject running with exaggerated or forced thoracic (shoulder) rotation. To learn more about the context of the experiment and check out my results please visit [my website](https://alexduman.weebly.com/shoulder_rotation.html).

**Video Data**
The video is a screen recording of the Vicon Motion Capture Skeleton so as to obscure the subject's identity, and was filmed in 1080p (1920 x 1080 pixels; w x h) at 60 frames per second for the 30 second duration of the trial. 

**Tabular Data**
The tabular data within the csv file contains seven (7) columns recorded at 2 kHz. The first, or left-most column, is the time expressed in seconds, and the subsequent columns are the unfiltered electromyographic (EMG; electrical activity) signals of the specified muscle. The first letter of the column header represents the side of the body (L = left, R = right) and the last two letters represent the muscle where I recorded the activity (LG = lateral gastrocnemius, MG = Medial gastrocnemius, RF = rectus femoris).

## MATLAB Tutorial
To reproduce the example GIF that is stored within the 'results' folder under the title 'Run_Forced_Rotation (MATLAB).gif', you will need to open up MATLAB to the appropriate directory and call the function with the appropriate assignments for each input (listed below).

You can accomplish this by typing the following line into your command line and hitting Enter/Return:
Animate_Figure('Run_Forced_Rotation_EMG.csv', 'Run_Forced_Rotation.mp4', 0.005, 2, 5, 'Forced Rotation')

After running this you should find a new file within the 'results' folder titled 'Run_Forced_Rotation.gif' which should be an exact copy of the 'Run_Forced_Rotation (MATLAB).gif' solution provided.


## Python Tutorial
To reproduce the example GIF that is stored within the 'results' folder under the title 'Run_Forced_Rotation (Python).gif', you will need to open the 'Animate_Figure.ipynb' Jupyter Notebook and Run All cells. 

As long as you left the Inputs in second cell alone (i.e. frameInc = 2 and durration = 4) you should find a new file within the 'results' folder titled 'Run_Forced_Rotation.gif' which should be an exact copy of the 'Run_Forced_Rotation (Python).gif' solution provided.
