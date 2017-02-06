# Kaggle Nature Conservancy Challenge

This repository contains my efforts for the Kaggle Nature Conservancy Challenge. Some of the work are linked from other Kaggler's repositories.

## Files
 - shiny_annotater.R contains a simple web-based shiny app for annotating images. It reads and writes to markers.csv, my personal annotations record
 - data/markers.csv contains my multiple annotations. Verified ranges:
   - ALB 0 - 852, 1714 - 1729 (50% of 1728)
   - BET 1729 - 1839 (111 of 197, 56%)
   - DOL 1925 - 2039 (116 of 116, 100%)
   - LAG 2040 - 2017 (69 of 69, 100%)
   - NoF not applicable
   - OTHER 2578 - 2800 (223 of 292, 76%)
   - SHARK 2869 - 2959 (90 of 176, 51%)
   - YFT 3044 - 3345 (301 of 735, 41%)
 - data/train.csv contains the 'merged' annotations from my markers.csv file and [nathaniel's annotations](https://github.com/nathanie/kaggleNatureConservancy)
 - Fish.ipynb contains the exploration and explanation behind the way I wrote my code. A functional 'productionalized' script will be released once the model and exploration has proved stable.
 - AWS.sh contains some shell commands used to launch an AWS GPU instance with the Udacity CarND Image, plus some environment setup

## Effort Tracker
 - tried pre-trained and from-scratch vgg16 on contain and coord with SGD lr > 1e-3 on train_fold1, will run into nan
 - tried smaller vgg16 (less features) with RMS prop lr 1e-4 for coord could get train MAE ~52 after 9 epochs for train_fold1, while validation MAE fluctuates around 40-50
 - tried full vgg16 net with max-all layer on verified annotations. Loss seems to decrease after 30 epochs but need to chart out history to verify. Can't get probability predictions with functional API; need to code out sequential model instead
 - try smaller nets for coord / contain?

## Quick Ref
Where multiple annotations exist (to isolate the fish of interest), the first annotation will always contain the fish of interest. Subsequent annotations might contain other fish species. YFT 2nd fish is usually a chopped tuna.

### Edge Cases
 - ALB img_03748.jpg has 4 fish
 - ALB img_03808.jpg has 3 fish
 - ALB img_03758.jpg fish at bottom left is labeled
 - BET img_02498.jpg has 7 fish
 - DOL img_01942.jpg has 4 fish
 - DOL img_06244.jpg - img_06962.jpg has 2 annotations for the same fish
 - LAG img_00091.jpg right broken fish not labeled
 - OTHER img_00698.jpg left ALB is labeled
 - SHARK img_00736.jpg has left ALB and YFT labeled
 - SHARK img_01759.jpg has 2 fish
 - YFT img_00222.jpg has left ALB labeled
 
