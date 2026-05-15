---
name: spring-boot
description: Spring Boot Java framework. Use when building Spring Boot apps, JPA/Hibernate repositories, REST controllers, Spring Security, Actuator health checks, or profile-based configuration.
---

## spring-boot

Production-grade Java framework with auto-configuration and embedded server for stand-alone applications.

### Core Concepts
- Auto-configuration: `@EnableAutoConfiguration` pulls in beans from classpath dependencies
- JPA/Hibernate: `@Entity` with `JpaRepository` interface for CRUD without boilerplate
- REST controllers: `@RestController` with `@RequestMapping` for JSON API endpoints
- Spring Security: `SecurityFilterChain` bean for authentication and authorization rules

### Common Patterns
- Actuator: `/actuator/health`, `/actuator/metrics` for production observability and monitoring
- Profiles: `application-dev.yml`/`application-prod.yml` for environment-specific config
- Testing: `@WebMvcTest` with `MockMvc` for controller-layer testing, `@DataJpaTest` for repos
- Dependency injection: `@Autowired` or constructor injection with `@Service`/`@Repository` beans

### Best Practices
- Prefer constructor injection over `@Autowired` field injection for testability and immutability
- Use `@Transactional` at the service layer, not the controller, for consistent transaction boundaries
- Keep controllers thin: delegate business logic to `@Service` classes
- Validate request bodies with `@Valid` and custom `@Constraint` annotations

### Common Code Patterns
- `@RestController @RequestMapping("/api/users")` with `@GetMapping("/{id}")` for REST
- `public interface UserRepo extends JpaRepository<User, Long>` for auto-implemented CRUD
