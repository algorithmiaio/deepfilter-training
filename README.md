# DeepFilter Training

![DeepFilter Example](http://blog.algorithmia.com/wp-content/uploads/2016/11/gan_vogh_example2.png)

[DeepFilter](https://algorithmia.com/algorithms/deeplearning/DeepFilter) is a fun way to convert photos or images into the style of a masterpiece painting, drawing, etc. For instance, you could apply the artistic style of Van Gogh’s Starry Night to an otherwise boring photo of the Grand Canal in Venice, Italy.

This is a guide to help you get started in training your own DeepFilters.

![AMI Creating Image](https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/ami_creation.png)

## 1. Training DeepFilter

1. First of, you'll need a valid AWS account so you can start off by creating an EC2 `p2.xlarge` instance with our AMI image. (`ami-b19aafa6`)

2. Git clone this repository by using the following command: `git clone https://github.com/algorithmiaio/deepfilter-training.git`

3. Run the following command: `. deepfilter-training/install_environment.sh` to setup the environment for DeepFilter training. (installing may take up to an hour or two)

4. Change directory into `texture_nets` via the command `cd texture_nets`, and download a style image using the following command: `wget <url_to_image>`. Later rename the style image file via: `mv <image_filename> style.jpg`.

5. Start training via the command: `th train.lua -data dataset -style_image style.jpg -style_size 600 -image_size 512 -model johnson -batch_size 4 -learning_rate 1e-2 -style_weight 10 -style_layers relu1_2,relu2_2,relu3_2,relu4_2 -content_layers relu4_2`

Training will continue until it hits 50k iterations. You'll find all of your model files under the folder `data/checkpoints`.

![Iteration Example](https://s3.amazonaws.com/algorithmia-assets/github_repo/deepfilter-training/iteration_example.png)
## 2. Testing DeepFilter

TODO

# Credits

TODO
