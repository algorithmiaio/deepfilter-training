#!/bin/bash
set -e

# Wait for apt-get to get unlocked
echo -n "Initializing installation script "
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
  echo -n "."
   sleep 1
done
echo ""

echo "Have you read and accepted the following TOS & EULA for the following:"
echo "    NVIDIA Driver TOS: http://www.nvidia.com/content/DriverDownload-March2009/licence.php?lang=us"
echo "    NVIDIA CUDA EULA: http://developer.download.nvidia.com/compute/cuda/7.5/Prod/docs/sidebar/EULA.pdf"
echo "    NVIDIA CUDNN License: https://developer.nvidia.com/rdp/assets/cudnn-65-eula-asset"
echo "    COCO2014 Image Dataset: http://mscoco.org/terms_of_use/"
read -p "If you've read and accepted the TOS, EULA and licenses, please enter (Y|n): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 150

  curl -LO http://us.download.nvidia.com/XFree86/Linux-x86_64/361.28/NVIDIA-Linux-x86_64-361.28.run && chmod +x NVIDIA-Linux-x86_64-361.28.run && sudo ./NVIDIA-Linux-x86_64-361.28.run --silent

  sudo update-alternatives --set gcc /usr/bin/gcc-4.8

  curl -LO https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/cuda_7.5.18_linux.run && chmod +x cuda_7.5.18_linux.run && sudo ./cuda_7.5.18_linux.run --silent --toolkit
  curl -LO https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/cudnn-7.5-linux-x64-v5.1.tgz && tar -xf cudnn-7.5-linux-x64-v5.1.tgz && sudo mv cuda/include/* /usr/local/cuda/include && sudo mv cuda/lib64/* /usr/local/cuda/lib64

  nvidia-modprobe -c 0 && nvidia-modprobe -c 0 -u
  nvidia-smi

  sudo update-alternatives --set gcc /usr/bin/gcc-5

  git clone https://github.com/torch/distro.git ~/torch --recursive
  cd ~/torch; bash install-deps;

  sudo update-alternatives --set gcc /usr/bin/gcc-4.8

  echo -ne '\n' | ./install.sh

  cd ~

  . torch/install/bin/torch-activate

  # Fix for broken Torch rocks installation
  # Peg git-hash version numbers
  torch_commit="426e2989de5ef3e759b1e10efe94bd04c170efda"
  sys_commit="f073f057d3fd2148866eaa0444a62ababfdf935e"
  cutorch_commit="bcbb427c4d7322a4e88f867a19193940677dfabc"
  loadcaffe_commit="6b6c58831980db9a09af2fd26bbd82247f116575"
  nn_commit="9b2f1ef7c45204f5c278bbdc55e367fcdd29e70e"
  cunn_commit="8d35db45bbb2ad35d3a045d7ebe185b1f9efc505"
  optim_commit="89ef52a03b1c39c645d96023b8748ef84973d4f6"
  image_commit="674c8d184b35d3e46e6bea54465b6c7b390d076f"
  cudnn_commit="970d7249e5c680d20ecac98edebe1f507feeecac"

  # Change directory to home directory
  cd ~

  # Install torch rock from source. Equilavent of: luarocks install torch (as of Dec 8th 2016)
  git clone https://github.com/torch/torch7.git /tmp/torch7 --recursive \
  && cd /tmp/torch7 \
  && git checkout "$torch_commit" \
  && luarocks make rocks/torch-scm-1.rockspec \
  && cd ~ \
  && rm -rf /tmp/torch7

  # Install sys rock from source. Equilavent of: luarocks install sys (as of Dec 8th 2016)
  git clone https://github.com/torch/sys.git /tmp/sys --recursive \
  && cd /tmp/sys \
  && git checkout "$sys_commit" \
  && luarocks make sys-1.1-0.rockspec \
  && cd ~ \
  && rm -rf /tmp/sys

  # Install cutorch rock from source. Equilavent of: luarocks install cutorch (as of Dec 8th 2016)
  git clone https://github.com/torch/cutorch.git /tmp/cutorch --recursive \
  && cd /tmp/cutorch \
  && git checkout "$cutorch_commit" \
  && luarocks make rocks/cutorch-scm-1.rockspec \
  && cd ~ \
  && rm -rf /tmp/cutorch

  # Install loadcaffe rock from source. Equilavent of: luarocks install loadcaffe (as of Dec 8th 2016)
  git clone https://github.com/szagoruyko/loadcaffe.git /tmp/loadcaffe --recursive \
  && cd /tmp/loadcaffe \
  && git checkout "$loadcaffe_commit" \
  && luarocks make loadcaffe-1.0-0.rockspec \
  && cd ~ \
  && rm -rf /tmp/loadcaffe

  # Install nn rock from source. Equilavent of: luarocks install nn (as of Dec 8th 2016)
  git clone https://github.com/torch/nn.git /tmp/nn --recursive \
  && cd /tmp/nn \
  && git checkout "$nn_commit" \
  && luarocks make rocks/nn-scm-1.rockspec \
  && cd ~ \
  && rm -rf /tmp/nn

  # Install cunn rock from source. Equilavent of: luarocks install cunn (as of Dec 8th 2016)
  git clone https://github.com/torch/cunn.git /tmp/cunn --recursive \
  && cd /tmp/cunn \
  && git checkout "$cunn_commit" \
  && luarocks make rocks/cunn-scm-1.rockspec \
  && cd ~ \
  && rm -rf /tmp/cunn

  # Install optim rock from source. Equilavent of: luarocks install optim (as of Dec 8th 2016)
  git clone https://github.com/torch/optim.git /tmp/optim --recursive \
  && cd /tmp/optim \
  && git checkout "$optim_commit" \
  && luarocks make optim-1.0.5-0.rockspec \
  && cd ~ \
  && rm -rf /tmp/optim

  # Install image rock from source. Equilavent of: luarocks install image (as of Dec 8th 2016)
  git clone https://github.com/torch/image.git /tmp/image --recursive \
  && cd /tmp/image \
  && git checkout "$image_commit" \
  && luarocks make image-1.1.alpha-0.rockspec \
  && cd ~ \
  && rm -rf /tmp/image

  # Install cudnn rock from source. Equilavent of: luarocks install cudnn (as of Dec 8th 2016)
  git clone https://github.com/soumith/cudnn.torch.git /tmp/cudnn.torch --recursive \
  && cd /tmp/cudnn.torch \
  && git checkout "$cudnn_commit" \
  && luarocks make cudnn-scm-1.rockspec \
  && cd ~ \
  && rm -rf /tmp/cudnn.torch

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

  sudo update-alternatives --set gcc /usr/bin/gcc-5

  curl -sSf https://raw.githubusercontent.com/algorithmiaio/algorithmia-cli/master/install.sh | sh
fi
