#' Create Hex Stickers using text-to-image via Stable Diffusion R Packages



txt2img4rHEX <- function(text_prompts,
                         package_name,
                         number_of_images = 3){

  # Verify the types of the input parameters
  assertthat::assert_that(assertthat::is.string(text_prompts))
  assertthat::assert_that(assertthat::is.string(package_name))
  assertthat::assert_that(assertthat::is.count(number_of_images))

  # Create the prompt
  pr <- text_prompts

  # Generate the image via Stable Diffusion
  res <- txt2img4R(text_prompts = pr,
                   negative_prompts = "text, low quality, noisy, blurry",
                   height = 512*2,
                   width = 512*2,
                   number_of_images = number_of_images,
                   steps = 15,
                   cfg_scale = 7,
                   clip_guidance_preset = "NONE",
                   sampler = "NONE",
                   seed = 0,
                   style_preset = "NONE",
                   engine_id = "stable-diffusion-v1-5",
                   api_host = "https://api.stability.ai",
                   api_key = Sys.getenv("DreamStudio_API_KEY"),
                   verbose = TRUE)

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
