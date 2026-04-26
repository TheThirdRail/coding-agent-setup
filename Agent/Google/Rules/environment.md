# Environment

Use this rule when installing dependencies, selecting tooling, or changing setup instructions.

## Constraints

- Prefer project-local tools, wrappers, environments, manifests, and lockfiles over global installs.
- Avoid global dependency installs unless the user explicitly requests them.
- Use lockfiles or equivalent pinned manifests where the ecosystem supports them.
- Surface required tools, services, auth, environment variables, and repo state when they materially affect success.
- Python: use local `venv`, `.venv`, `uv`, or Poetry environments.
- Node.js: use local `node_modules` and lockfiles such as `package-lock.json`, `pnpm-lock.yaml`, or `yarn.lock`.
- Ruby: use Bundler with the project `Gemfile` and `Gemfile.lock`.
- Java: use project build wrappers such as `mvnw` or `gradlew` and project dependency manifests.
- .NET: use project or solution restore and local tool manifests for project tooling.
- Other ecosystems: use the ecosystem's project-scoped dependency manager and pinned versions where supported.
