---
name: vercel-ai-browser
description: Browser automation with Vercel AI SDK patterns using Playwright MCP. Use when testing web apps, taking screenshots, scraping content, or automating browser interactions.
---

<auto_trigger>
- "browser", "playwright", "e2e", "end to end"
- "screenshot", "take screenshot", "capture page"
- "click button", "fill form", "type text"
- "test the app", "test this page", "check the site"
- "scrape", "scraping", "extract content"
- "visual test", "visual regression"
- "browser automation", "automate browser"
- Testing Next.js app in browser
- Taking screenshots of pages
- Automating form submissions
</auto_trigger>

<objective>
Provide intelligent browser automation for testing, scraping, and interaction using Playwright MCP tools with Vercel AI SDK best practices. This skill helps you control browsers through natural language while following modern React/Next.js testing patterns.
</objective>

<when_to_use>
- Testing Next.js/React applications in a browser
- Scraping web content or taking screenshots
- Automating form submissions and interactions
- Visual regression testing
- E2E testing with AI-assisted assertions
</when_to_use>

<available_tools>
You have access to Playwright MCP tools:
- `browser_navigate` - Navigate to a URL
- `browser_snapshot` - Get accessibility tree (preferred over screenshot for actions)
- `browser_take_screenshot` - Capture visual state
- `browser_click` - Click elements by ref
- `browser_type` - Type text into inputs
- `browser_fill_form` - Fill multiple form fields at once
- `browser_evaluate` - Run JavaScript on page
- `browser_console_messages` - Get console output
- `browser_network_requests` - Inspect network activity
- `browser_wait_for` - Wait for text or conditions
</available_tools>

<patterns>

## Testing Next.js Apps

```typescript
// 1. Navigate to the app
browser_navigate({ url: "http://localhost:3000" })

// 2. Get accessibility snapshot (better than screenshot for finding elements)
browser_snapshot()

// 3. Interact using refs from snapshot
browser_click({ element: "Login button", ref: "[ref-from-snapshot]" })

// 4. Fill forms efficiently
browser_fill_form({ fields: [
  { name: "Email", type: "textbox", ref: "[ref]", value: "test@example.com" },
  { name: "Password", type: "textbox", ref: "[ref]", value: "secret" }
]})
```

## Visual Testing Pattern

```typescript
// Take baseline screenshot
browser_take_screenshot({ filename: "baseline.png", fullPage: true })

// After changes, compare
browser_take_screenshot({ filename: "after-change.png", fullPage: true })

// Use Read tool to compare images visually
```

## Performance Testing Pattern

```typescript
// Navigate with network monitoring
browser_navigate({ url: "https://example.com" })

// Check network requests for waterfalls
browser_network_requests()

// Look for: sequential requests, large bundles, slow API calls
```

</patterns>

<best_practices>
1. **Always use browser_snapshot first** - It returns element refs needed for interactions
2. **Prefer fill_form over multiple type calls** - More reliable, faster
3. **Check console for errors** - Use browser_console_messages({ level: "error" })
4. **Wait for content, not time** - Use browser_wait_for({ text: "..." }) not arbitrary delays
5. **Screenshot at milestones** - Capture visual state for debugging
</best_practices>

<success_criteria>
- [ ] Used browser_snapshot to discover element refs
- [ ] Interactions use refs from the snapshot
- [ ] Errors and console messages are checked
- [ ] Screenshots captured for visual verification
</success_criteria>
