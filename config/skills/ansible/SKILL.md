---
name: ansible
description: Playbooks, inventory, roles, tasks/modules, handlers, Jinja2 templates, idempotency, ansible-galaxy, vault.
---

## ansible

Automate configuration management with Ansible.

### Playbooks
- YAML structure: hosts, tasks, vars, handlers
- Plays and play ordering
- Idempotent task design
- Tags for selective execution

### Inventory
- Static INI/YAML inventory files
- Dynamic inventory scripts
- Host and group variables
- Patterns: all, group, wildcards

### Modules and roles
- Core modules: copy, template, service, package
- Roles for reusable abstractions
- ansible-galaxy for community roles
- Role dependencies and defaults

### Advanced
- Jinja2 templating with filters
- Ansible Vault for secret encryption
- Fact gathering and caching
- Delegation and local_action
