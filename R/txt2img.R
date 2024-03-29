#' @title Text-to-image generator using Stable Diffusion
#' @description This function Generate an image from a text prompt using the Stable Diffusion API.
#'              It sends the parameters to the API and receives a response that includes
#'              the base64-encoded image data, which is then converted to a PNG image.
#'              For SDXL v0.9 and v1.0, the allowed dimensions are 1024x1024, 1152x896, 1216x832,
#'              1344x768, 1536x640, 640x1536, 768x1344, 832x1216, 896x1152.
#' @param text_prompts A string. The text prompt to use for image generation. Should not be empty.
#' @param negative_prompts A string. The negative prompts for image generation.
#' @param weight A numeric value indicating the weight of the text prompt. Default is 0.5.
#' @param height An integer. The height of the image in pixels. Default is 512.
#' @param width An integer. The width of the image in pixels. Default is 512.
#' @param number_of_images An integer. The number of images to generate. Default is 3.
#' @param steps An integer. The number of diffusion steps to run. Default is 10.
#' @param cfg_scale A numeric value. How strictly the diffusion process adheres to the prompt text. Default is 7.
#' @param clip_guidance_preset A string. A preset to guide the image model. Default is 'NONE'.
#' @param sampler A string. Which sampler to use for the diffusion process. If this value is omitted we'll automatically select an appropriate sampler for you.
#'    Default is NONE. Possible values are 'NONE', 'DDIM', 'DDPM', 'K_DPMPP_2M', 'K_DPMPP_2S_ANCESTRAL', 'K_DPM_2', 'K_DPM_2_ANCESTRAL', 'K_EULER', 'K_EULER_ANCESTRAL', 'K_HEUN', 'K_LMS'.
#' @param seed An integer. The seed for generating random noise. The range is 0 to 4294967295. The default is 0, which is the random noise seed.
#' @param style_preset A string. A style preset to guide the image model towards a particular style. Default is 'NONE'.
#'    Some possible values are: 'NONE', '3d-model', 'analog-film', 'anime', 'cinematic', 'comic-book', 'digital-art', 'enhance', 'fantasy-art', 'isometric', 'line-art', 'low-poly', 'modeling-compound', 'neon-punk', 'origami', 'photographic', 'pixel-art', 'tile-texture'.
#' @param engine_id A string. The engine id to be used in the API. Default is 'stable-diffusion-v1-5'.
#'    Other possible values are 'stable-diffusion-768-v2-1', 'stable-diffusion-512-v2-1', 'stable-diffusion-xl-1024-v1-0', 'stable-diffusion-xl-1024-v0-9', and 'stable-diffusion-xl-beta-v2-2-2'.
#' @param api_host A string. The host of the Stable Diffusion API. Default is 'https://api.stability.ai'.
#' @param api_key A string. The API key for the Stable Diffusion API. It is read from the 'DreamStudio_API_KEY' environment variable by default.
#' @param verbose A logical flag to print the message Default is TRUE.
#' @importFrom assertthat assert_that is.string is.count noNA
#' @importFrom httr add_headers POST http_status content
#' @importFrom jsonlite fromJSON
#' @importFrom base64enc base64decode
#' @importFrom png readPNG
#' @importFrom EBImage rotate Image display
#' @return A list of images generated from the text prompt.
#' @export txt2img
#' @author Satoshi Kume
#' @examples
#' \dontrun{
#' Sys.setenv(DreamStudio_API_KEY = "Your API key")
#' text_prompts = "japanese castle"
#' images = txt2img(text_prompts)
#' Display(images)
#' }

txt2img <- function(
  text_prompts = "",
  negative_prompts = "text, low quality, noisy, blurry",
  weight = 0.5,
  height = 512,
  width = 512,
  number_of_images = 1,
  steps = 10,
  cfg_scale = 7,
  clip_guidance_preset = "NONE",
  sampler = "NONE",
  seed = 0,
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

  # Verify if api_key is not empty or NULL
  if (is.null(api_key) || api_key == "") {
    stop("api_key must not be empty or NULL")
  }

  height = 64*floor(height/64)
  width = 64*floor(width/64)

  assertthat::assert_that(
    assertthat::is.string(text_prompts),
    assertthat::is.string(negative_prompts),
    assertthat::is.number(weight),
    assertthat::noNA(weight),
    weight >= 0,
    weight <= 1,
    assertthat::is.count(height),
    height %% 64 == 0,
    height >= 128,
    assertthat::is.count(width),
    width %% 64 == 0,
    width >= 128,
    assertthat::is.count(number_of_images),
    number_of_images >= 1,
    number_of_images <= 10,
    assertthat::is.count(steps),
    steps >= 10,
    steps <= 150,
    assertthat::is.count(cfg_scale),
    cfg_scale >= 0,
    cfg_scale <= 35,
    assertthat::is.string(clip_guidance_preset),
    clip_guidance_preset %in% c("FAST_BLUE", "FAST_GREEN", "NONE", "SIMPLE", "SLOW", "SLOWER", "SLOWEST"),
    #assertthat::is.string(sampler),
    #is.null(sampler)
    sampler %in% c('NONE', 'DDIM', 'DDPM', 'K_DPMPP_2M', 'K_DPMPP_2S_ANCESTRAL', 'K_DPM_2', 'K_DPM_2_ANCESTRAL', 'K_EULER', 'K_EULER_ANCESTRAL', 'K_HEUN', 'K_LMS'),
    assertthat::is.string(engine_id),
    assertthat::is.string(style_preset),
    style_preset %in% c("NONE", "3d-model", "analog-film", "anime", "cinematic", "comic-book", "digital-art", "enhance", "fantasy-art", "isometric", "line-art", "low-poly", "modeling-compound", "neon-punk", "origami", "photographic", "pixel-art", "tile-texture"),
    engine_id %in% c("stable-diffusion-512-v2-1", "stable-diffusion-v1-5", "stable-diffusion-xl-beta-v2-2-2", "stable-diffusion-768-v2-1", "stable-diffusion-xl-1024-v1-0", "stable-diffusion-xl-1024-v0-9", "stable-diffusion-xl-beta-v2-2-2"),
    assertthat::is.string(api_host),
    assertthat::is.string(api_key)
  )

  uri <- paste0(api_host, "/v1/generation/", engine_id, "/text-to-image")

  headers <- httr::add_headers(
    "Content-Type" = "application/json",
    "Accept" = "application/json",
    "Authorization" = paste0("Bearer ", api_key)
  )

#For test
#text_prompts = "japanese castle"; negative_prompts = "text, low quality, noisy, blurry";weight = 0.5; height = 512; width = 512; number_of_images = 1; steps = 10; cfg_scale = 7; clip_guidance_preset = "NONE";
#sampler = "NONE"; seed = 0; style_preset = "NONE"; engine_id = "stable-diffusion-v1-5"; api_host = "https://api.stability.ai"; api_key = Sys.getenv("DreamStudio_API_KEY"); verbose = TRUE

#create a list
payload <- list(
    "text_prompts" = list(
      list("text" = text_prompts,
           "weight" = weight)
    ),
    negative_prompts = list(
      list("text" = negative_prompts)
    ),
    "cfg_scale" = cfg_scale,
    "clip_guidance_preset" = clip_guidance_preset,
    "height" = height,
    "width" = width,
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

result <- list()

for (i in seq_len(number_of_images)) {
    #i <- 1
    if(verbose){cat("Generate", i, "image\n")}

    if(seed == 0){
    payload[names(payload) == "seed"] <- sample(1:429496729, 1)
    }

    response <- httr::POST(uri,
                           body = payload,
                           encode = "json",
                           config = headers)

    if (httr::http_status(response)$category != "Success") {
      message("Non-200 response: ", httr::content(response, "text", encoding = "UTF-8"))
      return(result)
    }

    image_data <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

    decode_image <- png::readPNG(base64enc::base64decode(image_data$artifacts$base64))

    Img <- EBImage::rotate(EBImage::Image(decode_image, colormode = 'Color' ), angle=90)

    result[[i]] <- Img
    #str(result)
    attr(result[[i]], "arguments") <- payload
    #str(result)
    #imgDisplay(result)
  }

  #Images Output
  return(result)
}

