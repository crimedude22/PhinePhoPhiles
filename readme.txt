PhinePhoPhiles 1.0
******************************
An interface and collection of MATLAB scripts for processing recorded speech sounds.

Current Capabilities: 
*Denoising
*Pitch Shifting w/ Phase Vocoder
*Segmentation of long recordings into individual named files
*Maintaining file structure of phoneme files
*Segment debugging (renaming, deleting, etc.) interface

Future Capabilities:
*Amplitude Normalization
*Voice-onset alignment
*Not being heinously slow
*More elegant control of which transformations to apply/ability to start at any stage

-JLS 03.05.16
******************************
How to use:

Just run ProcPhoPhiles.m! It should prompt you through the rest. Parameters are (unfortunately) hard-coded in ProcPhoPhiles, but have hopefully been commented such that they can be changed easily

ResizeSegs is the only external script - use it to make segments have the same length by inserting zeros in short files, trimming long files. 