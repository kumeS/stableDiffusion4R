#' @title Text-to-image Japanese anime generator v01 using Stable Diffusion



txt2JPanime_v01 <- function(
    text_prompts = "",
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
    engine_id = "stable-diffusion-512-v2-1",
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

text_prompts0 <- "Anime style, vivid and ultra-sharp details, female characters interacting with nature,
floral elements, sunrise or bright sky, blend of fantastical and realistic textures, golden ratio composition,
acrylic palette knife technique, whimsical and detailed animation, pastel-colored natural backgrounds, cinematic art, trending aesthetics."
text_prompts1 = paste(text_prompts0, text_prompts)
text_prompts2 <- paste(unique(unlist(strsplit(gsub("\n  ", "", text_prompts1), "[,] "))), collapse = ", ")

negative_prompts = "Realistic style, dull and blurred details, text, low quality, noisy, blurry"

  assertthat::assert_that(
    assertthat::is.string(text_prompts2),
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
    engine_id %in% c("stable-diffusion-512-v2-1", "stable-diffusion-v1-5", "stable-diffusion-xl-beta-v2-2-2", "stable-diffusion-768-v2-1"),
    assertthat::is.string(api_host),
    assertthat::is.string(api_key)
  )

  uri <- paste0(api_host, "/v1/generation/", engine_id, "/text-to-image")

  headers <- httr::add_headers(
    "Content-Type" = "application/json",
    "Accept" = "application/json",
    "Authorization" = paste0("Bearer ", api_key)
  )

text_prompts2

result <- txt2img4R(
  text_prompts = text_prompts2,
  negative_prompts = negative_prompts,
  weight = weight,
  height = height,
  width = width,
  number_of_images = number_of_images,
  steps = steps,
  cfg_scale = cfg_scale,
  clip_guidance_preset = clip_guidance_preset,
  sampler = sampler,
  seed = seed,
  style_preset = style_preset,
  engine_id = engine_id,
  api_host = api_host,
  api_key = api_key,
  verbose = verbose)

return(result)

}

