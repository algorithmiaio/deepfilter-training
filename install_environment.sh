echo "Have you read and accepted the following TOS & EULA for the following:"
echo "    NVIDIA Driver TOS: http://www.nvidia.com/content/DriverDownload-March2009/licence.php?lang=us"
echo "    NVIDIA CUDA EULA: http://developer.download.nvidia.com/compute/cuda/7.5/Prod/docs/sidebar/EULA.pdf"
echo "    NVIDIA CUDNN License: https://developer.nvidia.com/rdp/assets/cudnn-65-eula-asset"
echo "    COCO2014 Image Dataset: http://mscoco.org/terms_of_use/"
read -p "If you've read and accepted the TOS, EULA and licenses, please enter (y): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 150

  curl -LO http://us.download.nvidia.com/XFree86/Linux-x86_64/361.28/NVIDIA-Linux-x86_64-361.28.run && chmod +x NVIDIA-Linux-x86_64-361.28.run && sudo ./NVIDIA-Linux-x86_64-361.28.run --silent

  sudo update-alternatives --set gcc /usr/bin/gcc-4.8

  curl -LO http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run && chmod +x cuda_7.5.18_linux.run && sudo ./cuda_7.5.18_linux.run --silent --toolkit
  curl -LO http://developer.download.nvidia.com/compute/redist/cudnn/v5.1/cudnn-7.5-linux-x64-v5.1.tgz && tar -xf cudnn-7.5-linux-x64-v5.1.tgz && sudo mv cuda/include/* /usr/local/cuda/include && sudo mv cuda/lib64/* /usr/local/cuda/lib64

  nvidia-modprobe -c 0 && nvidia-modprobe -c 0 -u
  nvidia-smi

  sudo update-alternatives --set gcc /usr/bin/gcc-5

  git clone https://github.com/torch/distro.git ~/torch --recursive
  cd ~/torch; bash install-deps;

  sudo update-alternatives --set gcc /usr/bin/gcc-4.8

  echo -ne '\n' | ./install.sh

  cd ~

  . torch/install/bin/torch-activate

  git clone https://github.com/DmitryUlyanov/texture_nets.git

  sudo apt-get install -y --force-yes libprotobuf-dev protobuf-compiler

  luarocks install --local loadcaffe

  export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

  cd texture_nets

  cd data/pretrained && bash download_models.sh && cd ../..

  wget http://msvocds.blob.core.windows.net/coco2014/train2014.zip
  wget http://msvocds.blob.core.windows.net/coco2014/val2014.zip
  unzip train2014.zip
  unzip val2014.zip
  mkdir -p dataset/train
  mkdir -p dataset/val
  ln -s `pwd`/val2014 dataset/val/dummy
  ln -s `pwd`/train2014 dataset/train/dummy
fi
