---
name: kubernetes
description: Pods, Deployments, Services, ConfigMaps/Secrets, Ingress, PVC, Helm charts, kubectl, namespaces, probes, RBAC.
---

## kubernetes

Orchestrate containers with Kubernetes.

### Core workloads
- Pods: containers, init containers, sidecars
- Deployments: replicas, rolling updates, rollback
- StatefulSets: stable network identity, persistent storage
- DaemonSets: run on every node

### Networking
- Services: ClusterIP, NodePort, LoadBalancer
- Ingress: path-based and host-based routing
- NetworkPolicies: pod-level firewall rules
- DNS: internal service discovery

### Configuration
- ConfigMaps: env vars, mounted files
- Secrets: base64 encoded, encryption at rest
- Resource requests and limits
- Liveness, readiness, startup probes

### Security
- RBAC: Roles, ClusterRoles, bindings
- ServiceAccounts with automount
- PodSecurityContext and SecurityContext
- Namespace isolation and quotas
