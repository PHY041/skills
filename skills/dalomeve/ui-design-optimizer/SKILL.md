# UI Design Optimizer Skill (ui 设计优化·模板)

An OpenClaw skill that provides design intelligence for building professional UI/UX across multiple platforms and frameworks. Adapted from the popular UI-UX Pro Max skill (37.5k stars).

## Description

此技能提供专业 UI/UX 设计智能，支持多平台和多框架。基于 UI-UX Pro Max 的核心能力，包含：

- **100 条行业推理规则** - 针对 SaaS、电商、医疗、金融等行业的专业设计建议
- **67 种 UI 风格** - Glassmorphism、Claymorphism、Minimalism、Brutalism、Bento Grid 等
- **96 种配色方案** - 行业特定的配色板
- **57 种字体配对** - 精选的 Google Fonts 组合
- **25 种图表类型** - 仪表盘和数据分析推荐
- **13 种技术栈** - React、Next.js、Vue、Nuxt、Svelte、Astro、SwiftUI、Flutter 等

## Installation

### Install from ClawHub

```bash
clawhub install ui-design-optimizer
```

### Manual Installation

Copy this skill folder to your OpenClaw skills directory:

```bash
# Clone or copy this folder to:
# ~/.openclaw/workspace/skills/local/ui-design-optimizer/
```

## Usage

### Trigger Patterns

The skill activates automatically when you request UI/UX design work:

- "设计一个 landing page"
- "创建一个 dashboard"
- "优化 UI 配色"
- "推荐字体配对"
- "生成设计系统"
- "build a landing page for my SaaS"
- "design a mobile app UI"
- "create a dark mode theme"

### Example Prompts

```
为我的美容 SPA 创建一个 landing page，使用柔和的配色和高端感觉

为 SaaS 产品设计一个 dashboard，需要深色模式和数据分析图表

设计一个电商网站，使用玻璃态风格和现代感

为金融科技应用创建移动端 UI，需要专业可信的视觉风格
```

## Features

### Design System Generator

The skill can generate a complete design system including:

- **Pattern**: Landing page structure (Hero, Features, Testimonials, CTA, etc.)
- **Style**: UI style recommendation (Glassmorphism, Minimalism, etc.)
- **Colors**: Industry-appropriate color palette with hex codes
- **Typography**: Font pairings with Google Fonts links
- **Effects**: Animation and interaction guidelines
- **Anti-patterns**: What NOT to do for your industry
- **Checklist**: Pre-delivery validation items

### Supported Industries

| Category | Examples |
|----------|----------|
| Tech & SaaS | SaaS, Micro SaaS, B2B Enterprise, Developer Tools, AI/Chatbot |
| Finance | Fintech, Banking, Crypto, Insurance, Trading Dashboard |
| Healthcare | Medical Clinic, Pharmacy, Dental, Veterinary, Mental Health |
| E-commerce | General, Luxury, Marketplace, Subscription Box |
| Services | Beauty/Spa, Restaurant, Hotel, Legal, Consulting |
| Creative | Portfolio, Agency, Photography, Gaming, Music Streaming |
| Emerging Tech | Web3/NFT, Spatial Computing, Quantum Computing |

### Available UI Styles (67)

**General Styles (49):**
- Glassmorphism, Claymorphism, Neumorphism, Brutalism
- Minimalism, Maximalism, Retro/Vintage, Cyberpunk
- Material Design, Fluent Design, iOS Human Interface
- And 39 more...

**Landing Page Styles (8):**
- Conversion-focused, Story-driven, Product-led
- And 5 more...

**Dashboard Styles (10):**
- Analytics, Admin Panel, BI/Reporting
- And 7 more...

### Supported Tech Stacks

| Category | Stacks |
|----------|--------|
| Web (HTML) | HTML + Tailwind (default) |
| React Ecosystem | React, Next.js, shadcn/ui |
| Vue Ecosystem | Vue, Nuxt.js, Nuxt UI |
| Other Web | Svelte, Astro |
| iOS | SwiftUI |
| Android | Jetpack Compose |
| Cross-Platform | React Native, Flutter |

## Design System Output Format

When generating a design system, the skill outputs:

```
+----------------------------------------------------------------------------------------+
| TARGET: [Project Name] - RECOMMENDED DESIGN SYSTEM                                     |
+----------------------------------------------------------------------------------------+
|                                                                                        |
| PATTERN: [Pattern Name]                                                                |
| Conversion: [Strategy]                                                                 |
| Sections: [List of sections]                                                           |
|                                                                                        |
| STYLE: [Style Name]                                                                    |
| Keywords: [Style keywords]                                                             |
| Best For: [Use cases]                                                                  |
| Performance: [Rating] | Accessibility: [WCAG level]                                    |
|                                                                                        |
| COLORS:                                                                                |
| Primary: #XXXXXX ([Name])                                                              |
| Secondary: #XXXXXX ([Name])                                                            |
| CTA: #XXXXXX ([Name])                                                                  |
| Background: #XXXXXX ([Name])                                                           |
| Text: #XXXXXX ([Name])                                                                 |
| Notes: [Color usage notes]                                                             |
|                                                                                        |
| TYPOGRAPHY: [Font Pairing]                                                             |
| Mood: [Typography mood]                                                                |
| Best For: [Use cases]                                                                  |
| Google Fonts: [URL]                                                                    |
|                                                                                        |
| KEY EFFECTS:                                                                           |
| [List of recommended effects and animations]                                           |
|                                                                                        |
| AVOID (Anti-patterns):                                                                 |
| [List of what NOT to do]                                                               |
|                                                                                        |
| PRE-DELIVERY CHECKLIST:                                                                |
| [ ] No emojis as icons (use SVG: Heroicons/Lucide)                                     |
| [ ] cursor-pointer on all clickable elements                                           |
| [ ] Hover states with smooth transitions (150-300ms)                                   |
| [ ] Light mode: text contrast 4.5:1 minimum                                            |
| [ ] Focus states visible for keyboard nav                                              |
| [ ] prefers-reduced-motion respected                                                   |
| [ ] Responsive: 375px, 768px, 1024px, 1440px                                           |
|                                                                                        |
+----------------------------------------------------------------------------------------+
```

## Persist Design System (Optional)

For long-term projects, you can persist the design system to files:

```
design-system/
├── MASTER.md          # Global Source of Truth
└── pages/
    └── dashboard.md   # Page-specific overrides
```

**Retrieval prompt:**
```
I am building the [Page Name] page. Please read design-system/MASTER.md. 
Also check if design-system/pages/[page-name].md exists. 
If the page file exists, prioritize its rules. 
If not, use the Master rules exclusively. 
Now, generate the code...
```

## Data Sources

The skill uses structured data for recommendations:

- `data/styles.csv` - 67 UI styles with keywords and use cases
- `data/colors.csv` - 96 color palettes by industry
- `data/typography.csv` - 57 font pairings with moods
- `data/patterns.csv` - 24 landing page patterns
- `data/charts.csv` - 25 chart type recommendations
- `data/rules.json` - 100 industry reasoning rules
- `data/stacks.json` - 13 tech stack guidelines

## Verification

After skill installation, verify with:

```bash
# Check skill structure
skills/local/skill-governance/scripts/audit-skill.ps1 -Root C:\Users\davemelo\.openclaw\workspace -SkillName ui-design-optimizer

# Reconcile ready skills
skills/local/skill-governance/scripts/reconcile-ready.ps1 -Root C:\Users\davemelo\.openclaw\workspace
```

## License

MIT License - Adapted from UI-UX Pro Max (nextlevelbuilder/ui-ux-pro-max-skill)

## Credits

Original project: https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
Official website: https://uupm.cc

This OpenClaw skill adapts the core design intelligence concepts for use within the OpenClaw agent ecosystem.
