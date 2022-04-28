# Updates
sudo apt-get update
sudo apt-get upgrade

# Install Java and create directory Streama
apt install openjdk-8-jre
mkdir /data
mkdir /data/streama
touch /data/streama/README.md

# New linux user
sudo adduser streama  # add password to README.md
sudo usermod -aG sudo streama
sudo chown streama:streama /data/streama/ -R

# download streama
cd /data/streama
sudo su streama
wget https://github.com/streamaserver/streama/releases/download/v1.10.4/streama-1.10.4.jar # or newer release
chmod ug+x streama-1.10.4.jar # make executable
ln -s streama-1.10.4.jar streama.jar # create link

# Execute Streama
sudo java -jar streama-1.10.4.jar