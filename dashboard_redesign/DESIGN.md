---
name: Vipingo Meridian
colors:
  surface: '#f9f9fc'
  surface-dim: '#dadadc'
  surface-bright: '#f9f9fc'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f6'
  surface-container: '#eeeef0'
  surface-container-high: '#e8e8ea'
  surface-container-highest: '#e2e2e5'
  on-surface: '#1a1c1e'
  on-surface-variant: '#414754'
  inverse-surface: '#2f3133'
  inverse-on-surface: '#f0f0f3'
  outline: '#717786'
  outline-variant: '#c1c6d7'
  surface-tint: '#005bc0'
  primary: '#0059bb'
  on-primary: '#ffffff'
  primary-container: '#0070ea'
  on-primary-container: '#fefcff'
  inverse-primary: '#adc7ff'
  secondary: '#b7102a'
  on-secondary: '#ffffff'
  secondary-container: '#db313f'
  on-secondary-container: '#fffbff'
  tertiary: '#9e3d00'
  on-tertiary: '#ffffff'
  tertiary-container: '#c64f00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc7ff'
  on-primary-fixed: '#001a41'
  on-primary-fixed-variant: '#004493'
  secondary-fixed: '#ffdad8'
  secondary-fixed-dim: '#ffb3b1'
  on-secondary-fixed: '#410007'
  on-secondary-fixed-variant: '#92001c'
  tertiary-fixed: '#ffdbcc'
  tertiary-fixed-dim: '#ffb695'
  on-tertiary-fixed: '#351000'
  on-tertiary-fixed-variant: '#7c2e00'
  background: '#f9f9fc'
  on-background: '#1a1c1e'
  surface-variant: '#e2e2e5'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.2'
  h1:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.25'
  h2:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.3'
  h3:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1'
    letterSpacing: 0.01em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  gutter: 20px
  margin: 24px
---

## Brand & Style

This design system is built on the pillars of **precision, reliability, and modern efficiency**. As a POS (Point of Sale) solution, the primary target audience includes business owners and frontline service staff who require a tool that is both powerful and unobtrusive. 

The aesthetic is **Modern Corporate**, drawing inspiration from high-end SaaS applications to elevate the user experience beyond traditional, clunky legacy POS software. We utilize a clean, systematic approach characterized by ample whitespace, a crisp grid-based layout, and a focus on functional clarity. The emotional response is intended to be one of "calm control"—minimizing cognitive load during busy service hours through predictable patterns and a sophisticated, trustworthy visual language.

## Colors

The palette is anchored by the signature blue from the logo, which serves as the primary action color for buttons, active states, and focus indicators. A deep, professional navy/neutral is used for typography and structural elements to ensure high contrast and legibility. 

- **Primary Blue:** Used for high-priority actions and navigational cues.
- **Secondary Red:** Reserved for critical alerts, deletions, or specific brand accents as seen in the logo mark.
- **Surface & Background:** We use a "Cool Gray" scale for backgrounds to reduce glare, with pure white surfaces for cards and modals to create clear containment.
- **Functional Colors:** Standardized success (green) and warning (amber) tones are tuned for accessibility, ensuring they remain distinguishable for users with color vision deficiencies.

## Typography

This design system employs a dual-font strategy to balance character with utility. **Manrope** is used for headlines to provide a modern, geometric, and friendly feel that remains professional. **Inter** is the workhorse for all body text, inputs, and data tables due to its exceptional readability and neutral, systematic nature.

Hierarchy is established through consistent weight stepping. Bold weights are reserved for headers and primary labels, while regular weights handle the bulk of information. On a POS system, font sizes are slightly enlarged compared to standard web apps to ensure quick readability from a distance (e.g., across a counter).

## Layout & Spacing

The layout follows a **Fixed-Fluid hybrid grid**. The main sidebar navigation is fixed at 280px, while the main content area utilizes a 12-column fluid grid that adapts to tablet and desktop screens. 

Spacing is based on a **4px base unit**. This creates a tight, professional rhythm suitable for information-dense environments like order lists and inventory tables.
- Use `md` (16px) for standard padding within cards and between input fields.
- Use `lg` (24px) for section margins and container gaps.
- Touch targets for buttons and interactive items must never be smaller than 44px in height to accommodate rapid finger-tapping on touchscreen POS hardware.

## Elevation & Depth

To maintain a modern aesthetic, we avoid heavy drop shadows. Instead, the design system utilizes **Tonal Layers** supplemented by very soft, ambient shadows to indicate interactivity and hierarchy.

- **Level 0 (Floor):** The background color (#F8FAFC).
- **Level 1 (Card):** White surfaces with a 1px border (#E2E8F0) or a very subtle shadow (0px 2px 4px rgba(0,0,0,0.05)).
- **Level 2 (Overlay):** Used for dropdowns and popovers. These feature a more pronounced shadow (0px 10px 15px rgba(0,0,0,0.1)) to visually lift them off the page.
- **Level 3 (Modal):** High-depth shadows with a backdrop blur (8px) to focus user attention on the critical task at hand.

## Shapes

The shape language is consistently **Rounded**. A 0.5rem (8px) radius is the default for most components, providing a modern, approachable feel without being overly "bubbly."

- **Standard (8px):** Buttons, Input fields, and small cards.
- **Large (16px):** Main dashboard containers and modals.
- **Pill (Full):** Used exclusively for status chips (e.g., "Paid," "Pending") to differentiate them from actionable buttons.

## Components

### Buttons
Primary buttons use the solid Primary Blue with white text. Hover states should darken the blue by 10%. Secondary buttons use a subtle gray outline with Primary Blue text. Buttons have a minimum height of 48px for touch-friendliness.

### Input Fields
Inputs feature a 1px light gray border that transitions to Primary Blue on focus. Use "Inter" for input text. Icons (User, Lock, Building) should be placed at the leading edge of the field in a muted gray (#94A3B8) to provide visual context without distraction.

### Cards & Lists
Order items in a list should be separated by a 1px horizontal hair-line. Use high-contrast typography for prices (Bold) and muted typography for item descriptions.

### Status Chips
Use pill-shaped containers with light background tints and darker text (e.g., Light Green background with Dark Green text for "Completed").

### Keypad (POS Specific)
For PIN entry or quantity adjustments, use a large-format grid of buttons. Each key should have a subtle Level 1 elevation to feel tactile on a touch screen.