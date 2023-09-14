#' Create Hex Stickers using text-to-image via Stable Diffusion R Packages

text_prompts <- "speed star, logo of deepRstudio, text logo, fast-looking, geometry, Seamless Language Translation, RStudio, translation, API"
package_name = "deepRstudio"
number_of_images = 1

txt2img4HEX <- function(text_prompts,
                         package_name,
                         number_of_images = 1){

  # Verify the types of the input parameters
  assertthat::assert_that(assertthat::is.string(text_prompts))
  assertthat::assert_that(assertthat::is.string(package_name))
  assertthat::assert_that(assertthat::is.count(number_of_images))

  # Create the prompt
  pr <- text_prompts

  # Generate the image via Stable Diffusion
  res <- txt2img(text_prompts = pr,
                   negative_prompts = "text, ((low quality)), noisy, blurry, background",
                   height = 512*2,
                   width = 512*2,
                   number_of_images = number_of_images,
                   steps = 20,
                   cfg_scale = 15,
                   clip_guidance_preset = "NONE",
                   sampler = "K_EULER_ANCESTRAL",
                   seed = 0,
                   style_preset = "NONE",
                   engine_id = "stable-diffusion-xl-1024-v1-0",
                   api_host = "https://api.stability.ai",
                   api_key = Sys.getenv("DreamStudio_API_KEY"),
                   verbose = TRUE)

  #imgDisplay(res, write_file = T)

  # Create the hex stickers
  img <- list()
  for(k in seq_len(n)){
    suppressMessages(
    img[[k]] <-  hexSticker::sticker(res[k],
                                     package = package_name,
                                     p_y = 1.5, p_size=12,
                                     s_x=1, s_y=.8, s_width=.5)
    )
  }

  # Return the result
  return(img)
}
