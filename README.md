# A RF-based Approach to Gesture Recognition
Gesture Recognition has a prominent importance in smart environment and home automation. Thanks to the availability of Machine Learning approaches it is possible for users to define gestures that can be associated with commands for the smart environment. 

### Project Objectives
In this project we propose a Random Forest-based approach for Gesture Recognition of hand movements starting from wireless wearable motion capture data. In the presented approach, we evaluate different feature extraction procedures to handle gestures and data with different duration.

### Project Organization
```
.
├── src/                                        : Contains report images
├── GR_Dataset.mat                              : Gesture dataset as MATLAB table
├── Gesture_Classification.m                    : Main routine
├── gesturePreprocessing.m                      : Preprocessing function for feature extraction
├── custom_MCCV.m                               : Custom function for Stratified Monte Carlo Cross Validation
├── Mdl_best_<PREPROCESSING_TYPE>.mat           : Models pretrained on <PREPROCESSING_TYPE> features and ready to use
└── README.md                                   : Project Report 
```

## Data Description
