# stableDiffusion4R

[GitHub/stableDiffusion4R](https://github.com/kumeS/stableDiffusion4R)

## Description

Artificial Intelligence (AI)-based image generation techniques are revolutionizing various fields, and this package brings those capabilities into the R environment. 
This package provides a seamless interface to integrate the 'Stable Diffusion' Web APIs (see <https://platform.stability.ai/docs/getting-started>) into R, allowing users to leverage advanced image transformation methods. Specifically, this package includes functions for text-to-image (txt2img or t2i) and image-to-image (img2img or i2i) transformations using the 'Stable Diffusion' APIs, enabling creative and analytical applications in data visualization and more.

## About this project 

- AI integration with R
  - [Stable Diffusion API](https://platform.stability.ai/docs/api-reference#tag/v1generation) / DreamStudio (txt2img, img2img, up-scaling/Super-resolution)
  
## R Functions
  
### Image generation functions using Stable Diffusion

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|txt2img4R|Text-to-image generator using Stable Diffusion|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/txt2img4R.R)||
|img2img4R|Image to Image Transformation using Stable Diffusion|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/img2img4R.R)||
|img2img_upscale4R|Stable Diffusion Image to Image Up-scaling Transformation|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/img2img_upscale4R.R)||

### Task specific image generation




### Visualization functions

|Function|Description|Script|Flowchart|
|:---|:---|:---:|:---:|
|imgDisplay|Display images and optionally write them into image files|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/Display.R)||
|imgDisplayAsMovie|Display Images as a Movie|[Script](https://github.com/kumeS/stableDiffusion4R/blob/main/R/DisplayAsMovie.R)||

## License

Copyright (c) 2023 Satoshi Kume. Released under the [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

## Cite

Kume S. (2023) stableDiffusion4R: Provision of stable diffusion interface for R

```
#BibTeX
@misc{Kume2023stableDiffusion4R,
  title={stableDiffusion4R: Provision of stable diffusion interface for R},
  author={Kume, Satoshi}, year={2023},
  publisher={GitHub}, note={R Package},
  howpublished={\url{https://github.com/kumeS/stableDiffusion4R}},
}
```

## Contributors

- Satoshi Kume

