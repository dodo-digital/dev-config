---
name: agent-browser
description: CLI browser automation tool optimized for AI agents. Uses ref-based selectors (@e1, @e2) and accessibility tree snapshots for 93% less context than Playwright MCP. Use when automating browsers, testing web apps, filling forms, taking screenshots, scraping content, or any browser interaction task.
---

# agent-browser

A CLI tool for browser automation designed specifically for AI agents. Uses accessibility tree snapshots with element references for efficient, low-context browser control.

## Quick Start

```bash
# Install globally
npm install -g agent-browser
agent-browser install  # Download Chromium

# Basic workflow
agent-browser open example.com
agent-browser snapshot -i          # Get interactive elements with @refs
agent-browser click @e2            # Click by ref
agent-browser fill @e3 "test@example.com"
agent-browser screenshot page.png
agent-browser close
```

## Core Workflow

The fundamental pattern is: **open -> snapshot -i -> interact with @refs -> re-snapshot**

1. **Navigate** to a URL with `open`
2. **Snapshot** the page with `-i` flag to get interactive elements with refs
3. **Interact** using the `@e1`, `@e2`, etc. refs from the snapshot
4. **Re-snapshot** after interactions to get updated refs

```bash
agent-browser open https://app.example.com/login
agent-browser snapshot -i
# Output shows: @e1 textbox "Email", @e2 textbox "Password", @e3 button "Sign In"
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser snapshot -i  # Re-snapshot to see new page state
```

## Essential Commands

### Navigation

| Command | Description |
|---------|-------------|
| `open <url>` | Navigate to URL (aliases: `goto`, `navigate`) |
| `back` | Go back in history |
| `forward` | Go forward in history |
| `reload` | Reload current page |
| `close` | Close browser |

### Snapshots (Key for AI)

```bash
agent-browser snapshot              # Full accessibility tree
agent-browser snapshot -i           # Interactive elements only (recommended)
agent-browser snapshot -c           # Compact format
agent-browser snapshot -d 3         # Limit depth to 3
agent-browser snapshot -s "#main"   # Scope to selector
agent-browser snapshot -i -c -d 5   # Combine options
```

The `-i` flag is critical - it filters to interactive elements only, reducing context significantly.

### Interactions

| Command | Description |
|---------|-------------|
| `click @ref` | Click element by ref |
| `fill @ref "text"` | Clear field and fill with text |
| `type @ref "text"` | Type text (preserves existing) |
| `press <key>` | Press key (Enter, Tab, Escape, etc.) |
| `hover @ref` | Hover over element |
| `select @ref "value"` | Select dropdown option |
| `check @ref` / `uncheck @ref` | Checkbox control |
| `scroll <dir> [px]` | Scroll (up/down/left/right) |

### Information Retrieval

```bash
agent-browser get text @e1      # Get text content
agent-browser get html @e1      # Get innerHTML
agent-browser get value @e1     # Get input value
agent-browser get title         # Page title
agent-browser get url           # Current URL
```

### State Checks

```bash
agent-browser is visible @e1    # Check visibility
agent-browser is enabled @e1    # Check if enabled
agent-browser is checked @e1    # Check checkbox state
```

### Screenshots and Media

```bash
agent-browser screenshot                 # Base64 to stdout
agent-browser screenshot page.png        # Save to file
agent-browser screenshot --full-page     # Full page capture
agent-browser pdf document.pdf           # Save as PDF
```

### Waiting

```bash
agent-browser wait @e1              # Wait for element
agent-browser wait 2000             # Wait milliseconds
agent-browser wait --text "Success" # Wait for text
agent-browser wait --url "dashboard"# Wait for URL pattern
agent-browser wait --load networkidle
```

## Semantic Locators

Find elements by role, text, or label instead of refs:

```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find label "Email" fill "test@test.com"
agent-browser find first ".item" click
agent-browser find nth 2 "a" text
```

## Sessions (Parallel Browsers)

Run isolated browser instances simultaneously:

```bash
agent-browser --session agent1 open site-a.com
agent-browser --session agent2 open site-b.com

agent-browser session list      # List all sessions
agent-browser session           # Show current session
```

Each session has separate: browser instance, cookies, storage, and auth state.

## Auth State Management

Save and restore authentication state:

```bash
# Login once, save state
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser state save auth.json

# Later, restore state to skip login
agent-browser state load auth.json
agent-browser open https://app.example.com/dashboard
```

## Browser Configuration

```bash
agent-browser set viewport 1920 1080    # Viewport size
agent-browser set device "iPhone 14"    # Device emulation
agent-browser set geo 37.7749 -122.4194 # Geolocation
agent-browser set offline on            # Offline mode
agent-browser set media dark            # Color scheme
```

## Storage and Cookies

```bash
agent-browser cookies                   # Get all cookies
agent-browser cookies set name value    # Set cookie
agent-browser storage local             # Get localStorage
agent-browser storage local set k v     # Set localStorage item
```

## Debugging

```bash
agent-browser console           # View console messages
agent-browser errors            # View page errors
```

## Common Patterns

### Form Submission

```bash
agent-browser open https://example.com/contact
agent-browser snapshot -i
# Output: @e1 textbox "Name", @e2 textbox "Email", @e3 textbox "Message", @e4 button "Send"
agent-browser fill @e1 "John Doe"
agent-browser fill @e2 "john@example.com"
agent-browser fill @e3 "Hello, I have a question..."
agent-browser click @e4
agent-browser wait --text "Thank you"
agent-browser snapshot -i
```

### E2E Testing

```bash
agent-browser open http://localhost:3000
agent-browser snapshot -i

# Test login flow
agent-browser click @e5  # "Sign In" link
agent-browser snapshot -i
agent-browser fill @e1 "test@test.com"
agent-browser fill @e2 "password"
agent-browser click @e3
agent-browser wait --url "dashboard"
agent-browser snapshot -i

# Verify dashboard loaded
agent-browser get text @e1  # Should show username
```

### Screenshot Documentation

```bash
agent-browser open https://app.example.com
agent-browser set viewport 1280 720
agent-browser screenshot docs/home.png
agent-browser click @e2  # Navigate
agent-browser wait --load networkidle
agent-browser screenshot docs/feature.png --full-page
```

## Guidelines

- **Always use `snapshot -i` before interactions** - this gives you the refs needed
- **Re-snapshot after major interactions** - refs change when the page updates
- **Use refs (`@e1`) over CSS selectors** - refs are more reliable and context-efficient
- **Combine snapshot flags** - `-i -c -d 5` reduces output significantly
- **Save auth state for repeated logins** - `state save/load` avoids re-authentication
- **Check console/errors for debugging** - helps diagnose failed interactions

## Installation Notes

### Linux Dependencies

```bash
agent-browser install --with-deps
# or: npx playwright install-deps chromium
```

### Verify Installation

```bash
agent-browser --version
agent-browser open https://example.com
agent-browser snapshot -i
agent-browser close
```

## Why agent-browser?

- **93% less context** than Playwright MCP tools
- **Ref-based selectors** (`@e1`, `@e2`) are optimal for AI agents
- **Accessibility tree snapshots** provide structured page understanding
- **Single CLI** instead of multiple MCP tool calls
- **Session support** for parallel browser instances
- **Auth state management** for persistent logins
