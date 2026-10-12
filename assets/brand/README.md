# Brand assets (proposal)

Status: proposal written 2026-10-11. The owner signs off logos.

- `logo.svg` / `logo-dark.svg`: a 300-degree arc, stroke 6 on a 64-unit box, round caps, gap on the right: "a harbor mouth". It is the same geometry as `Harbor/Views/HarborMark.swift` (arc from 30 to 330 degrees), so the app mark and the repo mark match.
- `wordmark.svg` / `wordmark-dark.svg`: mark plus "Harbor" in a semibold sans (Liberation Sans, converted to outlines). The app itself uses SF Pro; SF is not redistributable, so the wordmark does not.
- Colour: monochrome, white on black (dark) and black on white (light), following `DESIGN.md` ("brand voltage is white"). Contrast 21:1.
- Not the OpenRouter logo or monogram; see the licence/ToS notes in the README.
- Previews in `preview/`, rendered with `resvg`, optimised with `oxipng`.
