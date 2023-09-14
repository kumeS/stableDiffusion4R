# stableDiffusion4R

[GitHub/stableDiffusion4R](https://github.com/kumeS/stableDiffusion4R)

## Description

Artificial Intelligence (AI)-based image generation techniques are revolutionizing various fields, and this package brings those capabilities into the R environment. 
This package provides a seamless interface to integrate the 'Stable Diffusion' Web APIs (see <https://platform.stability.ai/docs/getting-started>) into R, allowing users to leverage advanced image transformation methods. Specifically, this package includes functions for text-to-image (txt2img or t2i) and image-to-image (img2img or i2i) transformations using the 'Stable Diffusion' APIs, enabling creative and analytical applications in data visualization and more.

This package was separated from the [chatAI4R](https://github.com/kumeS/chatAI4R) project.

## About this project 

- AI integration with R
  - [Stable Diffusion API](https://platform.stability.ai/docs/api-reference#tag/v1generation) / DreamStudio (txt2img, img2img, up-scaling/Super-resolution)
  - [DALL·E 2 / OpenAI API](https://platform.openai.com/docs/api-reference/images) (txt2img, img2img)

## Installation of the stableDiffusion4R package

### 1. Start R / RStudio console.

### 2. Run the following commands in the R console:

#### CRAN-version installation

```r
# CRAN-version installation (not yet)
install.packages("BiocManager", repos="http://cran.r-project.org")
BiocManager::install("EBImage")

#install.packages("stableDiffusion4R")
#library(stableDiffusion4R)
```

#### Dev-version installation (Recommended)

```r
# Dev-version installation
install.packages(c("devtools", "BiocManager"), repos="http://cran.r-project.org")
BiocManager::install("EBImage")

devtools::install_github("kumeS/stableDiffusion4R")
library(stableDiffusion4R)
```

### 3. Set the API Key According to each Web API

For example, to obtain a DreamStudio API key, please register as a member on the DreamStudio website (https://dreamstudio.ai/generate) and obtain your API key.

```r
# Set your key for the DreamStudio API
Sys.setenv(DreamStudio_API_KEY = "Your API key")
```

Create an .Rprofile file in your home directory and add your API key (using the code above) into it.

```{r}
# Create a file
file.create("~/.Rprofile") 

# [MacOS X] Open the file and edit it
system(paste("open ~/.Rprofile"))
```

Note: Please be aware of newline character inconsistencies across different operating systems.

## Prompts for chatGPT / GPT-4

|File|Description|Prompt|
|:---|:---|:---:|
||A prompt to analyze themes for unified imagery|[Prompt](https://github.com/kumeS/stableDiffusion4R/blob/main/inst/chatGPT_prompts/CraftingUnifiedImagery_v01.txt)|


## R Functions
  
### Image generation functions using Stable Diffusion

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|txt2img4R|Text-to-image generator using Stable Diffusion|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/txt2img4R.R)||
|img2img4R|Image to Image Transformation using Stable Diffusion|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/img2img4R.R)||
|img2img_upscale4R|Stable Diffusion Image to Image Up-scaling Transformation|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/img2img_upscale4R.R)||

### Task specific image generation


### Image generation functions using DALL·E 2  

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|generateImage4R|Generate Images Using OpenAI API|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/generateImage4R.R)||
|editImage4R|Edit or Extend Images with OpenAI API|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/editImage4R.R)||
|imageVariation4R|Generate Image Variations using OpenAI API|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/imageVariation4R.R)||
|createImagePrompt_v1|create a prompt for generating an image from text using an AI model|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/createImagePrompt_v1.R)||
|createImagePrompt_v2|create a more complex prompt by considering additional attributes|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/createImagePrompt_v2.R)||

### Visualization functions

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|Display|Display images and optionally write them into image files|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/Display.R)||
|createHEX|Create Hex Stickers for R Packages (experimental)|[Script](https://github.com/kumeS/chatAI4R/blob/main/R/createHEX.R)|[Flowchart](https://github.com/kumeS/chatAI4R/blob/main/inst/flowchart/createHEX.png)|




### Visualization functions

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|imgDisplay|Display images and optionally write them into image files|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/Display.R)||
|imgDisplayAsMovie|Display Images as a Movie|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/DisplayAsMovie.R)||

## License

Copyright (c) 2023 Satoshi Kume. Released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Cite

Kume S. (2023) stableDiffusion4R: R Interface to 'Stable Diffusion' APIs for AI-Driven Creative Image Transformations

```
#BibTeX
@misc{Kume2023stableDiffusion4R,
  title={stableDiffusion4R: R Interface to 'Stable Diffusion' APIs for AI-Driven Creative Image Transformations},
  author={Kume, Satoshi}, year={2023},
  publisher={GitHub}, note={R Package},
  howpublished={\url{https://github.com/kumeS/stableDiffusion4R}},
}
```

## Contributors

- Satoshi Kume

