---
name: cypress
description: E2E testing, cy commands, assertions, fixtures, intercept (network), component testing, custom commands, CI (cypress run).
---

## cypress

End-to-end testing with Cypress.

### Core concepts
- cy.visit, cy.get, cy.contains
- Assertions: .should(be.visible), .and(have.text)
- Chaining commands for sequences
- Automatic retry-ability

### Fixtures and network
- Fixtures for test data files
- cy.intercept for network mocking
- cy.wait for API response sync
- Stub and spy on XHR/fetch requests

### Component testing
- Mount React, Vue, Angular components
- Test component interactions in isolation
- Same API as E2E tests
- Fast feedback without full page load

### CI and best practices
- cypress run for headless execution
- cypress run --headed for debugging
- Cypress Cloud for dashboard and recording
- Custom commands with Cypress.Commands.add
- Page Object Model for maintainability
