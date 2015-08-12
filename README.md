## Getting and Cleaning Data Course Project

This file outlines the course project submission for Getting and Cleaning Data (Coursera) #31, starting August 3rd, 2015.  The project objective was to create a tidy dataset from accelerometry data collected from the Samsung Galaxy S smartphone.  I created a script in R ver 3.2.1 titled <code>run_analysis.R</code> which automatically cleans the data and outputs it to "ProjectData.txt" which is saved in the working directory.

### Assumptions

This script assumes that you have saved the data files avilable from <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"">here</a> on your local machine, and that your current working directory is in the "UCI HAR Dataset" folder.  Running the command <code>list.files()</code> in your  current working directory should return the following list:  

<code>"activity_labels.txt" "features.txt" "features_info.txt" "README.txt" "test" "train"</code>  

### Dependencies

The script is dependent on the following libraries in addition to base R: <code>plyr</code> <code>dplyr</code> <code>car</code>.  The script checks to see if these libraries are installed and, if not, installs them before loading the libraries.  If you are  loading libraries, you must load <code>plyr</code> prior to <code>dplyr</code> or a critical function of <code>dplyr</code> will not run properly, and the script will produce an error.

### Script Steps

The script loads the data and generates a tidy dataset using the following general steps.

1. Checks for required packages <code>plyr</code> <code>dplyr</code> <code>car</code> and installs them if they are not found.
2. Loads required libraries.
3. Reads in the training and test data sets.
4. Reads in the labels for the training and test sets.
5. Reads in the subject IDs for the training and test sets.
6. Reads in the features file and creates a vector of column names for variables.
7. Merges training and test data sets.
8. Merges labels and subjects columns to dataset created in #7.
9. Adds column labels to the dataset created in #8.
10. Sorts data by subject, then by label.
11. Selects the data columns containing "Subject", "Label", "Mean", "Std" and creates a new dataset with only those variables.
12. Removes angle and frequency mean columns<sup>1</sup>.
13. Calculates an arithmetic mean value (average) for each activity + subject combination.
14. Replaces the label numbers (column 2) with descriptive names.
15. Cleans up the variable names to remove extra punctuation characters<sup>2</sup>.
16. Writes a new file "ProjectData.txt" and outputs it to the current working directory.

### Footnotes.

1. The filter for mean and std automatically included several columns with meanFreq and angle...mean...  These have been excluded from the dataset based on the following information from the "features_info.txt" document:
      - Angle mean variables are calculated as an average of signals in a signal window sample and thus are not true mean values and are excluded.
	  - meanFreq values are a weighted average of the frequency component and not an arithmetic mean and are excluded.
	  
2. I have chosen not to expand variable name abbreviations (e.g. Acc) into full words (e.g. Accelerometer) for ease of use of the individual using this dataset for further analysis.  Variable names with many characters are unwieldy in statistical software, thus abbreviations are preferred for column names if they can be clarified elsewhere.  A codebook is included to aid the user in parsing the variable names.