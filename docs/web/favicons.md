# RealFaviconGenerator

[RealFaviconGenerator](https://realfavicongenerator.net/) is a web service that
generates the full set of favicon assets from a single source image: PNG icons
for every platform, the web app manifest, Apple touch icons, and the HTML markup
to include in the `<head>`.

No installation required. The service runs entirely in the browser.

## Why favicons are complex

A single `favicon.ico` is no longer sufficient. Modern browsers and platforms
expect:

| Asset | Used by |
| --- | --- |
| `favicon.ico` | Legacy browsers, browser tabs |
| `favicon-32x32.png`, `favicon-16x16.png` | Modern browsers |
| `apple-touch-icon.png` (180×180) | iOS home screen |
| `android-chrome-192x192.png`, `512x512.png` | Android, PWA |
| `site.webmanifest` | Web app manifest (name, theme color, icons) |

## Workflow

1. Prepare a square PNG source image, at least 512×512 pixels, with a
  non-transparent background (required for iOS).
2. Upload it to RealFaviconGenerator.net.
3. Configure platform-specific options (background color, theme color, tile
  color for Windows).
4. Download the generated package and extract it into the project's `public/`
  directory.
5. Copy the HTML snippet into the base Twig template.

## Twig integration

Place the generated markup in the `<head>` block of `templates/base.html.twig`:

```twig
<link rel="apple-touch-icon" sizes="180x180" href="{{ asset('apple-touch-icon.png') }}">
<link rel="icon" type="image/png" sizes="32x32" href="{{ asset('favicon-32x32.png') }}">
<link rel="icon" type="image/png" sizes="16x16" href="{{ asset('favicon-16x16.png') }}">
<link rel="manifest" href="{{ asset('site.webmanifest') }}">
```

Use the Symfony `asset()` function so the paths go through the asset versioning
pipeline.

## Checklist

- Source image is square and at least 512×512 px.
- Background is not transparent (iOS renders a black background otherwise).
- `site.webmanifest` declares `name` and `short_name`.
- All generated files are committed in the project repository, not in this setup
  repository.
