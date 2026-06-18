# Image services

## Overview

This page documents web services and local tools useful for image manipulation
during web development. None of these require installation in this setup.

## remove.bg

[remove.bg](https://www.remove.bg/) is a web service that automatically removes
the background from an image. It also exposes a REST API.

### Usage

Upload an image on the website or call the API:

Set the `REMOVE_BG_API_KEY` environment variable first, then call the API:

```bash
curl -s -X POST https://api.remove.bg/v1.0/removebg \
  -F "image_file=@photo.jpg" \
  -F "size=auto" \
  -H "X-Api-Key: ${REMOVE_BG_API_KEY}" \
  -o no-bg.png
```

### Limits and privacy

- The free tier processes a limited number of images per month at reduced
  resolution.
- Images are transmitted to and processed on remove.bg servers. Do not upload
  images that contain personal data or confidential content.
- For batch processing of non-sensitive images, the API is practical. For
  sensitive images, prefer a local alternative.

### Local alternative

GIMP can remove backgrounds manually. For scripted batch processing, ImageMagick
can apply a color-based removal:

```bash
magick input.png -fuzz 10% -transparent white output.png
```

Results are less clean than remove.bg for complex backgrounds.

## ImageMagick

[ImageMagick](https://imagemagick.org/) is a command-line image processing tool.
It is not installed in this setup but is a common dependency.

Install it if needed:

```bash
brew install imagemagick
```

### Common commands

Resize an image while preserving aspect ratio:

```bash
magick input.png -resize 1600x output.png
```

Convert format and reduce quality:

```bash
magick input.png -quality 85 output.jpg
```

Strip metadata (EXIF, GPS) before publishing:

```bash
magick input.jpg -strip output.jpg
```

Batch convert a directory:

```bash
for f in *.png; do magick "$f" -resize 1600x "resized/${f%.png}.jpg"; done
```

### When to use ImageMagick vs other tools

| Need | Tool |
| --- | --- |
| Background removal (quick) | remove.bg |
| Background removal (sensitive data) | GIMP (manual) |
| Resize / convert / strip metadata | ImageMagick |
| Manual retouching | GIMP |
