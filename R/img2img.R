#' @title  Image to Image Transformation using Stable Diffusion
#' @description This function uses the Stable Diffusion process to transform
#' an initial image according to given prompts.
#' @param text_prompts A string. The text prompt to guide image transformation. Should not be empty.
#' @param init_image_path A string. This is the path to the image file to be used as the basis for the image to image transformation. Should be a valid PNG file.
#' @param init_image_mode A string. Determines whether to use 'image_strength' or 'step_schedule_*' to control the influence of the initial image. Default is 'IMAGE_STRENGTH'.
#' @param image_strength A numeric value. Specifies the influence of the initial image on the diffusion process. Default is 0.35.
#' @param weight A numeric value. Indicates the weight of the text prompt. Default is 0.5.
#' @param number_of_images An integer. The number of images to generate. Default is 1.
#' @param steps An integer. The number of diffusion steps to run. Default is 15.
#' @param cfg_scale A numeric value. How strictly the diffusion process adheres to the prompt text. Default is 7.
#' @param seed An integer. The seed for generating random noise. The range is 0 to 4294967295. The default is 0, which is the random noise seed.
#' @param clip_guidance_preset A string. A preset to guide the image model. Default is 'NONE'.
#' @param sampler A string. Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you. Default is NONE. Possible values are 'DDIM', 'DDPM', 'K_DPMPP_2M', 'K_DPMPP_2S_ANCESTRAL', 'K_DPM_2', 'K_DPM_2_ANCESTRAL', 'K_EULER', 'K_EULER_ANCESTRAL', 'K_HEUN', 'K_LMS'.
#' @param style_preset A string. A style preset to guide the image model towards a particular style. Default is 'NONE'. Some possible values are: '3d-model', 'analog-film', 'anime', 'cinematic', 'comic-book', 'digital-art', 'enhance', 'fantasy-art', 'isometric', 'line-art', 'low-poly', 'modeling-compound', 'neon-punk', 'origami', 'photographic', 'pixel-art', 'tile-texture'.
#' @param engine_id A string. The engine id to be used in the API. Default is 'stable-diffusion-v1-5'.
#'                  Other possible values are 'stable-diffusion-512-v2-1', 'stable-diffusion-768-v2-1', 'stable-diffusion-xl-1024-v1-0', 'stable-diffusion-xl-1024-v0-9', and 'stable-diffusion-xl-beta-v2-2-2'.
#' @param api_host A string. The host of the Stable Diffusion API. Default is 'https://api.stability.ai'.
#' @param api_key A string. The API key for the Stable Diffusion API. It is read from the 'DreamStudio_API_KEY' environment variable by default.
#' @param verbose A logical flag to print the message Default is TRUE.
#' @importFrom assertthat assert_that is.string is.number is.count noNA
#' @importFrom httr add_headers POST http_status content
#' @importFrom jsonlite fromJSON
#' @importFrom base64enc base64decode
#' @importFrom png readPNG
#' @importFrom EBImage rotate Image readImage resize writeImage
#' @return A list of images generated from the initial image and the text prompt.
#' @export img2img
#' @author Satoshi Kume
#' @examples
#' \dontrun{
#' text_prompts <- "Add a cat"
#' init_image_path <- system.file("img", "JP_castle.png", package = "chatAI4R")
#' images = img2img(text_prompts, init_image_path)
#' Display(images)
#' }

img2img <- function(
  text_prompts,
  init_image_path,
  init_image_mode = "IMAGE_STRENGTH",
  image_strength = 0.35,
  weight = 0.5,
  number_of_images = 1,
  steps = 15,
  cfg_scale = 7,
  seed = 0,
  clip_guidance_preset = "NONE",
  sampler = "NONE",
  style_preset = "NONE",
  engine_id = "stable-diffusion-v1-5",
  api_host = "https://api.stability.ai",
  api_key = Sys.getenv("DreamStudio_API_KEY"),
  verbose = TRUE
) {

  # Verify if text_prompts is not empty or NULL
  if (is.null(text_prompts) || text_prompts == "") {
    stop("text_prompts must not be empty or NULL")
  }

  assertthat::assert_that(
    assertthat::is.string(text_prompts),
    assertthat::is.number(weight),
    assertthat::noNA(weight),
    weight >= 0,
    weight <= 1,
    assertthat::is.count(number_of_images),
    number_of_images >= 1,
    number_of_images <= 10,
    assertthat::is.count(steps),
    steps >= 10,
    steps <= 150,
    assertthat::is.count(cfg_scale),
    cfg_scale >= 0,
    cfg_scale <= 35,
    sampler %in% c('NONE', 'DDIM', 'DDPM', 'K_DPMPP_2M', 'K_DPMPP_2S_ANCESTRAL', 'K_DPM_2', 'K_DPM_2_ANCESTRAL', 'K_EULER', 'K_EULER_ANCESTRAL', 'K_HEUN', 'K_LMS'),
    assertthat::is.string(clip_guidance_preset),
    clip_guidance_preset %in% c("FAST_BLUE", "FAST_GREEN", "NONE", "SIMPLE", "SLOW", "SLOWER", "SLOWEST"),
    assertthat::is.string(engine_id),
    assertthat::is.string(style_preset),
    engine_id %in% c("stable-diffusion-512-v2-1", "stable-diffusion-v1-5", "stable-diffusion-xl-beta-v2-2-2", "stable-diffusion-768-v2-1", "stable-diffusion-xl-1024-v1-0", "stable-diffusion-xl-1024-v0-9", "stable-diffusion-xl-beta-v2-2-2"),
    assertthat::is.string(api_host),
    assertthat::is.string(api_key)
  )

  #check image
  a <- EBImage::readImage(init_image_path)
  if(!(dim(a)[1]%%64 == 0 && dim(a)[2]%%64 == 0)){
  b <- EBImage::resize(a,
                w = round(dim(a)[1]/64,0)*64,
                h = round(dim(a)[2]/64,0)*64)

  #save
  tempD <- tempdir()
  EBImage::writeImage(b,
                      files = paste0(tempD, "/", sub(".png$", "R.png", basename(init_image_path))),
                      type = "png")
  image_path <- paste0(tempD, "/", sub(".png$", "R.png", basename(init_image_path)))
  }else{
  image_path <- init_image_path
  }

  # Defining the URL
  uri <- paste0(api_host, "/v1/generation/", engine_id, "/image-to-image")

  headers <- httr::add_headers(
    "Content-Type" = "multipart/form-data",
    "Accept" = "application/json",
    "Authorization" = paste0("Bearer ", api_key)
  )

payload <- list(
    "text_prompts[0][text]" = text_prompts,
    "text_prompts[0][weight]" = weight,
    "init_image" = httr::upload_file(image_path),
    "init_image_mode" = init_image_mode,
    "image_strength" = image_strength,
    "cfg_scale" = cfg_scale,
    "clip_guidance_preset" = clip_guidance_preset,
    "samples" = number_of_images,
    "steps" = steps,
    "seed" = seed,
    "sampler" = sampler,
    "style_preset" = style_preset
  )

if(sampler == "NONE"){
payload <- payload[names(payload) != "sampler"]
}

if(style_preset == "NONE"){
payload <- payload[names(payload) != "style_preset"]
}


  # Creating empty variable
  result <- list()
  attr(result, "arguments") <- payload


  for (i in seq_len(number_of_images)) {
    if(verbose){cat("Generating", i, "image\n")}

    response <- httr::POST(uri,
                           body = payload,
                           encode = "multipart",
                           config = headers)

    if (httr::http_status(response)$category != "Success") {
      stop("Non-200 response: ", httr::content(response, "text", encoding = "UTF-8"))
    }

    image_data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

    decode_image <- png::readPNG(base64enc::base64decode(image_data$artifacts$base64))

    Img <- EBImage::rotate(EBImage::Image(decode_image, colormode = 'Color' ), angle=90)

    result[[i]] <- Img
  }

  return(result)
}
