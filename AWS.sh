# using Udacity's Car Image

gofish # alias for navigating to the project's directory
ssh-add ~/Dropbox/Code/keys/aws_nvirgnia.pem

export AWS=54.173.57.31 # change as necessary
ssh ubuntu@$AWS
# git clone --recursive https://github.com/wongjingping/kaggle-nature-conservancy.git
git clone https://github.com/wongjingping/kaggle-nature-conservancy.git
cd kaggle-nature-conservancy/data
git submodule init
git submodule update
mkdir ~/kaggle-nature-conservancy/models
pip install seaborn
sudo apt install unzip
# disconnect
exit

# then transfer file from local, and unzip
scp data/train.zip ubuntu@$AWS:kaggle-nature-conservancy/data
ssh ubuntu@$AWS
cd kaggle-nature-conservancy/data
unzip train.zip # takes ~ 2 mins

# or download from kaggle directly
scp ~/Dropbox/Code/keys/kaggle_cookies.txt ubuntu@$AWS:~/
ssh ubuntu@$AWS
wget --load-cookies kaggle_cookies.txt https://www.kaggle.com/c/the-nature-conservancy-fisheries-monitoring/download/train.zip -O data/train.zip

# start screen and run the ipython notebook server+
screen
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888

# when resuming
export AWS=54.145.43.85 # change as necessary
ssh ubuntu@$AWS
cd kaggle-nature-conservancy
git pull origin master
screen
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888