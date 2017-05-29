## Codebook: Getting & Cleaning Data
Using R packages for extracting, transforming and analyzing UCI ML repo data 

## Dataset used
UCI HAR (Univ. of Calif. @ Irvine, Human Activity Recognition ML repo)

url "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## Input Data & Variables
`activity_labels.txt`:  Links the class labels with their activity name.

`features.txt</pre`: List of all features.

`features_info.txt`: Shows information about the variables used on the feature vector.

`test/X_test.txt</pre`: Test set.

`test/Y_test.txt`: Test labels.

`train/X_train.txt`: Train set.

`train/Y_train.txt`: Train labels.

## Datasets available for training & testing
` train/subject_train.txt`: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

` train/Inertial Signals/total_acc_x_train.txt`: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Each row has 128 elements. The same description applies to 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for both the Y and Z axes i.e.

` train/Inertial Signals/body_acc_x_train.txt`: The body acceleration signal obtained = total acceleration - gravity.

` train/Inertial Signals/body_gyro_x_train.txt`: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

## Data Transformation

Each input file is read into its respective variable and the subjects in training and test set data are merged to form `subject`. The activities in training and test set data are merged to form `activity`. 

The features of test and training are merged to form features and the name of the `features` are set in features from `featureNames`.

Features, activity and subject are merged to form `completeData` and the indices of columns that contain std or mean, activity and subject are taken into `requiredColumns`. And, `extractedData` is created with data from columns in `requiredColumns`.

Activity column in extractedData is updated with descriptive names of activities taken from activityLabels. Activity column is expressed as a factor variable. Acronyms in variable names in extractedData, like 'Acc', 'Gyro', 'Mag', 't' and 'f' are replaced with descriptive labels such as 'Accelerometer', 'Gyroscpoe', 'Magnitude', 'Time' and 'Frequency'.

`tidyData` is created as a set with average for each activity and subject of `extractedData`. Entries in tidyData are ordered based on activity, subject, and the data in tidyData is written into `Tidy.txt`.

## Output Data Set
The output data `Tidy.txt` is a a space-delimited value file. It contains the mean and standard deviation values of the data contained in the input files.
