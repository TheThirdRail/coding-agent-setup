# Frontend Accessibility Patterns

## WCAG Baseline Checklist
- Perceivable: alt text, sufficient contrast, non-color-only cues.
- Operable: keyboard access, visible focus, no keyboard traps.
- Understandable: explicit labels, clear validation and error copy.
- Robust: valid semantic markup and compatible ARIA usage.

## Reusable Patterns

### Skip Link
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### Form Field with Description
```html
<label for="email">Email Address</label>
<input id="email" type="email" aria-required="true" aria-describedby="email-help" />
<span id="email-help">We'll never share your email.</span>
```

### Accessible Modal Requirements
- Trap focus inside modal while open.
- Restore prior focus on close.
- Close on `Escape`.
- Provide `aria-labelledby` and `aria-describedby`.

## Responsive Guidance
- Start mobile-first, then scale up.
- Validate layouts at key breakpoints (`sm`, `md`, `lg`, `xl`).
- Prefer fluid units (`rem`, `%`, `vw`) over fixed pixel layouts.
