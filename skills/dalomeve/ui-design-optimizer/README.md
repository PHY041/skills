# UI Design Optimizer (ui 设计优化·模板)

Professional UI/UX design intelligence skill for OpenClaw agents.

## Features

- 🎨 **67 UI Styles** - Glassmorphism, Claymorphism, Minimalism, Brutalism, and more
- 🌈 **96 Color Palettes** - Industry-specific color schemes
- ✒️ **57 Font Pairings** - Curated typography combinations
- 📐 **24 Landing Page Patterns** - Proven conversion structures
- 🧠 **100 Reasoning Rules** - Industry-specific design guidelines
- ♿ **Accessibility Checks** - WCAG compliance validation

## Installation

### From ClawHub (recommended)

```bash
clawhub install ui-design-optimizer
```

### Manual

```bash
# This skill is located at:
# skills/local/ui-design-optimizer/
```

## Usage

The skill activates automatically when you request UI/UX design work.

### Example Prompts

```
为我的美容 SPA 创建一个 landing page，使用柔和的配色和高端感觉

为 SaaS 产品设计一个 dashboard，需要深色模式和数据分析图表

设计一个电商网站，使用玻璃态风格和现代感

Build a landing page for my SaaS product

Design a mobile app UI for e-commerce

Create a fintech banking app with dark theme
```

### Direct Script Usage

```powershell
# Generate design system
.\scripts\search.ps1 -Query "beauty spa wellness" -DesignSystem -ProjectName "Serenity Spa"

# Generate with persistence
.\scripts\search.ps1 -Query "SaaS dashboard" -DesignSystem -Persist -ProjectName "MyApp"

# Search specific domains
.\scripts\search.ps1 -Query "glassmorphism" -Domain style
.\scripts\search.ps1 -Query "fintech" -Domain color
.\scripts\search.ps1 -Query "elegant" -Domain typography
```

## Supported Industries

| Industry | Product Types |
|----------|---------------|
| Tech & SaaS | SaaS, Micro SaaS, B2B, Developer Tools, AI |
| Finance | Fintech, Banking, Crypto, Insurance, Trading |
| Healthcare | Medical, Pharmacy, Dental, Veterinary, Mental Health |
| E-commerce | General, Luxury, Marketplace, Subscription |
| Services | Beauty/Spa, Restaurant, Hotel, Legal, Consulting |
| Creative | Portfolio, Agency, Photography, Gaming, Music |
| Emerging Tech | Web3, Spatial Computing, Quantum, Autonomous |

## Output Format

The skill generates a complete design system:

```
+--------------------------------------------------------------------------------+
| TARGET: Serenity Spa - RECOMMENDED DESIGN SYSTEM                               |
+--------------------------------------------------------------------------------+
| PATTERN: Hero-Centric + Social Proof                                           |
| STYLE: Soft UI Evolution                                                       |
| COLORS: Primary: #E8B4B8 (Soft Pink), Secondary: #A8D5BA (Sage Green)          |
| TYPOGRAPHY: Cormorant Garamond / Montserrat                                    |
| KEY EFFECTS: Soft shadows, Smooth transitions, Gentle hover states             |
| AVOID: Bright neon colors, Harsh animations, Dark mode                         |
| CHECKLIST: [ ] No emojis, [ ] cursor-pointer, [ ] Hover states, etc.           |
+--------------------------------------------------------------------------------+
```

## Tech Stacks

The skill supports guidelines for:

- **Web**: HTML + Tailwind (default)
- **React**: React, Next.js, shadcn/ui
- **Vue**: Vue, Nuxt.js, Nuxt UI
- **Other**: Svelte, Astro
- **Mobile**: SwiftUI, Jetpack Compose, React Native, Flutter

## License

MIT License

## Credits

Adapted from [UI-UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) (37.5k stars)

Original by: nextlevelbuilder
Official website: https://uupm.cc
