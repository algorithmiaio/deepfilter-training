# DeepFilter Training

![DeepFilter Example](https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/gan_vogh_example2.png)

[DeepFilter](https://algorithmia.com/algorithms/deeplearning/DeepFilter) is a fun way to convert photos or images into the style of a masterpiece painting, drawing, etc. For instance, you could apply the artistic style of Van Gogh’s Starry Night to an otherwise boring photo of the Grand Canal in Venice, Italy.

This is a guide to help you get started in training your own DeepFilters.

![AMI Creating Image](https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/ami_creation.png)

## 1. Training DeepFilter

1. First of, you'll need a valid AWS account so you can start off by creating an EC2 `p2.xlarge` instance with our AMI image. (`ami-b19aafa6`)

2. Git clone this repository by using the following command: `git clone https://github.com/algorithmiaio/deepfilter-training.git`

3. Run the following command: `. deepfilter-training/install_environment.sh` to setup the environment for DeepFilter training. (installing may take up to an hour or two)

4. Change current directory into `texture_nets` via the command `cd texture_nets`.

5. Download a style image using the following command: `wget <url_to_image>`.

6. Rename the style image file via: `mv <image_filename> style.jpg`.

7. Start training via the command: `th train.lua -data dataset -style_image style.jpg -style_size 600 -image_size 512 -model johnson -batch_size 4 -learning_rate 1e-2 -style_weight 10 -style_layers relu1_2,relu2_2,relu3_2,relu4_2 -content_layers relu4_2`

Training will continue until it hits 50k iterations. You'll find all of your model files under the folder `data/checkpoints`.

**Note:** You may play with the training settings to get different results. For more information regarding parameter optimization, please refer to:

* [DmitryUlyanov/texture_nets - Documentation](https://github.com/DmitryUlyanov/texture_nets/blob/master/README.md)
* [DmitryUlyanov/texture_nets - Issues regarding parameters](https://github.com/DmitryUlyanov/texture_nets/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aopen%20parameter).

![Iteration Example](https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/iteration_example.png)
## 2. Testing DeepFilter

1. Install the Algorithmia client via: `curl -sSf https://raw.githubusercontent.com/algorithmiaio/algorithmia-cli/master/install.sh | bash`

2. Login to your algorithmia account with your API key via: `algo auth`

4. Create a new collection in your account to store your model file via: `algo mkdir .my/DeepFilterTraining`

4. Copy your 50k model file to new collection: `algo cp data/checkpoints/model_50000.t7 data://.my/DeepFilterTraining/my_model.t7`

5. Test your new model: `algo run deeplearning/DeepFilter/0.5.x -d {"images": ["data://deeplearning/example_data/elon_musk.jpg"],"savePaths": ["data://.my/DeepFilterTraining/stylized.jpg"],"filterName": "data://.my/DeepFilterTraining/my_model.t7"}`

6. View your stylized image [here](https://algorithmia.com/v1/data/<username>/DeepFilterTraining/stylized.jpg): (`https://algorithmia.com/v1/data/<username>/DeepFilterTraining/stylized.jpg`) (You need to be logged in, and need to change `<username>` with your login name.)

# Credits

This guide is based on code provided by: [DmitryUlyanov/texture_nets](https://github.com/DmitryUlyanov/texture_nets).
