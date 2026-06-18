# GIMP

## Overview

[GIMP](https://www.gimp.org/) (GNU Image Manipulation Program) is an open-source
image editor. It is used for manual retouching, background removal, cropping, and
export tasks that require precision or work with sensitive images that cannot be
sent to a cloud service.

It is installed through Homebrew and declared in the project `Brewfile`.

## Installation

It is part of the curated Homebrew environment; see [`Homebrew setup`](../homebrew/homebrew.md) to install everything at once.

Install GIMP directly:

```bash
brew install --cask gimp
```

Verify the installation:

```bash
brew list --cask | grep -x gimp
```

## Common tasks

### Background removal

1. Open the image (`File → Open`).
2. Add an alpha channel: `Image → Flatten Image` then `Image → Alpha to Selection`,
  or directly `Filters → Colors → Color to Alpha`.
3. Use `Fuzzy Select` (magic wand) to select the background.
4. Press `Delete` to remove it.
5. Export as PNG to preserve transparency: `File → Export As → filename.png`.

### Cropping and resizing

Crop to a selection: draw a rectangle with the `Rectangle Select` tool, then
`Image → Crop to Selection`.

Resize the canvas: `Image → Scale Image`. Set the width and lock the aspect ratio.

### Export for the web

`File → Export As` opens the export dialog. For PNG: adjust compression level
(6 is a good default). For JPEG: set quality between 80 and 90 for web use.

Strip metadata before publishing: `File → Export As → Show All Options →
uncheck Save EXIF data, Save IPTC data, Save XMP data`.

## When to use GIMP vs remove.bg

| Situation | Tool |
| --- | --- |
| Quick background removal, non-sensitive image | remove.bg |
| Sensitive image (client data, personal photos) | GIMP |
| Complex manual retouching | GIMP |
| Batch resizing or format conversion | GIMP (Script-Fu) |

## Rollback

Remove GIMP with Homebrew:

```bash
brew uninstall --cask gimp
```

Then remove its entry from `profiles/full/Brewfile`.
