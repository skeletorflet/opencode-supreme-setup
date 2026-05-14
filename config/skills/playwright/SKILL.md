---
name: playwright
description: Browser automation with Playwright — testing, scraping, and E2E workflows. Use when you need to automate browser interactions, write E2E tests, or scrape web content.
---

## playwright

Browser automation with Playwright.

### Installation
npm init playwright@latest
npx playwright install chromium

### Core concepts
- Browser: Chrome, Firefox, Safari
- Context: isolated browser session
- Page: single tab
- Locator: find elements (page.locator())
- Assertion: verify state (expect())

### Common patterns
- Navigate: page.goto(url)
- Click: page.click(selector)
- Type: page.fill(selector, text)
- Wait: page.waitForSelector(selector)
- Screenshot: page.screenshot()
- Evaluate: page.evaluate(js)

### Best practices
- Use locators over XPath/CSS when possible
- Test user flows, not implementation
- Parallel test execution
- Screenshot on failure
- Use fixtures for test data
- Mock network requests for reliability
