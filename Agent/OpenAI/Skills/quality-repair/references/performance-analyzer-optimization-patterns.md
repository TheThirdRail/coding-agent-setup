# Performance Optimization Patterns

## Database Optimizations
- Add indexes for high-frequency filters, joins, and sorts.
- Remove N+1 query paths with eager loading or batched fetches.
- Use `EXPLAIN ANALYZE` for every modified query.
- Paginate high-cardinality endpoints.

## Caching Strategies
- Application cache for hot, stable data.
- HTTP caching for static or infrequently changing responses.
- Query/result caching for expensive reads with explicit invalidation.
- Memoization for deterministic heavy computations.

## Code and Runtime Optimizations
- Replace high-complexity algorithms with better asymptotic alternatives.
- Parallelize independent I/O operations.
- Batch remote calls and writes where feasible.
- Reuse connection pools for databases and HTTP clients.

## Frontend Optimizations
- Code split route-level and expensive component bundles.
- Lazy-load media and non-critical components.
- Optimize images and static assets.
- Reduce render churn with memoization and stable props.

## Quick Wins
- Enable compression (gzip/brotli).
- Add request/response size limits and pagination defaults.
- Minimize payload shape to only required fields.
- Introduce sane cache headers for read-heavy endpoints.
