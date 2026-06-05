# Design System

Theme tokens live in `Shared/Enums/AppTheme.swift`. The iOS design system lives
under `{AppName}/{AppName}/DesignSystem/`.

Use existing tokens and primitives before adding new styling. Never declare
ad-hoc spacing, radii, typography, materials, or animation when a token already
exists.

## Layers

### Tokens — `DesignSystem/Tokens/`

`Radii`, `Spacing`, `Typography`, `Motion`, `Materials`.

Use these instead of raw values like `.cornerRadius(16)`, `.padding(12)`,
`Font.system(size: 14)`, or `Animation.spring(...)`.

### Primitives — `DesignSystem/Primitives/`

`Surface`, `GlassChrome`, `GlassCapsule`, `RowItem`, `TransportButton`,
`Scrubber`, `SectionHeader`, `EmptyState`.

The `Surface` / `GlassChrome` split is load-bearing: `Surface` is for opaque
content, `GlassChrome` is for glass chrome. Do not mix these roles.

### Chrome — `DesignSystem/Chrome/`

`LiquidGlassTabBar`, `MiniPlayer`, `NowPlayingSheet`, `NowPlayingContent`,
`MiniPlayerExpansion`.

`App/AppShell.swift` is the single root that owns the tab bar, mini-player,
sheet layout, and matched-geometry coordination. Feature views must not reach
into chrome internals.

## Chrome vs Content

Use glass only for chrome with a refractable backdrop. Use opaque surfaces for
content that needs legibility — never glass for dense text, forms, editors, or
confirmation dialogs.

| Surface                     | Material                   |
| --------------------------- | -------------------------- |
| Tab bar                     | `Materials.chromeGlass`    |
| Mini-player                 | `Materials.chromeGlass`    |
| NowPlayingSheet header      | `Materials.chromeGlass`    |
| Provider chip               | `Materials.capsuleTier`    |
| Device chip                 | `Materials.capsuleTier`    |
| Transport buttons on chrome | `Materials.controlTier`    |
| Settings form sections      | `Materials.contentSurface` |
| Override editor sheet       | `Materials.contentSurface` |
| Dropdowns and menus         | `Materials.popoverSurface` |
| Destructive confirmations   | `Materials.popoverSurface` |

## Navigation IA

Four tabs: Library (default launch), Tango, Settings, Search.

Now Playing is not a tab — it is the expanded state of the persistent
`MiniPlayer` above the tab bar. When a song is selected from Library or Search:

1. Play the track.
2. Call `MiniPlayerExpansion.requestExpand()`.
3. Let `NowPlayingSheet` animate from the mini-player using the matched-geometry
   namespace owned by `AppShell`.

## Motion

Use only these roles. Do not write custom spring animations
(`withAnimation(.spring(...))`) in feature code.

| Role           | Purpose                                             |
| -------------- | --------------------------------------------------- |
| `Motion.pop`   | transport taps, button presses, active-line scale   |
| `Motion.ease`  | selection, hint dismissal, incidental state changes |
| `Motion.sheet` | mini-player expansion and sheet presentation        |

## Accessibility

Every interactive element needs an accessibility label — buttons, capsules,
transport controls, scrubbers, menu triggers, and custom rows with tap actions.
`TransportButton` exposes its label by construction.

- Typography tokens use relative text styles so Dynamic Type works by default.
- Glass falls back to opaque material when Reduce Transparency is enabled.
- Matched-geometry transitions degrade gracefully when Reduce Motion is enabled.

## Improving UI

Prioritize: spacing → hierarchy → alignment → legibility → interaction states →
responsiveness. Use color and animation only after the structure is solid.

Do not redesign a whole screen unless explicitly asked, and preserve layout
constraints the user calls out.
