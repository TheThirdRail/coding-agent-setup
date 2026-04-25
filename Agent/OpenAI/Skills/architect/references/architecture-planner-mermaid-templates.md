# Mermaid Diagram Templates

Quick-copy templates for common architecture diagrams.

---

## C4 Context Diagram

```mermaid
C4Context
    title System Context Diagram

    Person(user, "User", "End user of the system")

    System(system, "System Name", "Main system being designed")

    System_Ext(externalA, "External System A", "Description")
    System_Ext(externalB, "External System B", "Description")

    Rel(user, system, "Uses")
    Rel(system, externalA, "Calls API")
    Rel(system, externalB, "Sends data to")
```

---

## C4 Container Diagram

```mermaid
C4Container
    title Container Diagram

    Person(user, "User", "End user")

    Container_Boundary(c1, "System Boundary") {
        Container(web, "Web App", "React", "SPA frontend")
        Container(api, "API Server", "Node.js", "REST API")
        ContainerDb(db, "Database", "PostgreSQL", "Stores data")
        Container(cache, "Cache", "Redis", "Session storage")
    }

    System_Ext(external, "External API", "Third-party service")

    Rel(user, web, "Uses", "HTTPS")
    Rel(web, api, "Calls", "REST/JSON")
    Rel(api, db, "Reads/Writes")
    Rel(api, cache, "Caches")
    Rel(api, external, "Calls", "HTTPS")
```

---

## Sequence Diagram

```mermaid
sequenceDiagram
    autonumber

    participant U as User
    participant C as Client
    participant A as API
    participant D as Database

    U->>C: Action
    C->>A: POST /api/resource

    activate A
    A->>D: INSERT INTO table
    D-->>A: OK
    A-->>C: 201 Created
    deactivate A

    C-->>U: Success message

    Note over A,D: Transaction boundary

    alt Success
        C->>U: Show success
    else Failure
        C->>U: Show error
    end
```

---

## Flowchart

```mermaid
flowchart TD
    A[Start] --> B{Decision?}
    B -->|Yes| C[Process A]
    B -->|No| D[Process B]
    C --> E[Step 1]
    D --> E
    E --> F{Another Check}
    F -->|Pass| G[Continue]
    F -->|Fail| H[Handle Error]
    H --> I[Retry?]
    I -->|Yes| E
    I -->|No| J[Exit with Error]
    G --> K[End]
```

---

## Class Diagram

```mermaid
classDiagram
    class User {
        +String id
        +String email
        +String name
        +Date createdAt
        +login()
        +logout()
    }

    class Order {
        +String id
        +String userId
        +List~Item~ items
        +Decimal total
        +submit()
        +cancel()
    }

    class Item {
        +String id
        +String name
        +Decimal price
        +Int quantity
    }

    User "1" --> "*" Order : places
    Order "*" --> "*" Item : contains
```

---

## Entity Relationship Diagram

```mermaid
erDiagram
    USER {
        uuid id PK
        string email UK
        string name
        timestamp created_at
    }

    ORDER {
        uuid id PK
        uuid user_id FK
        decimal total
        string status
        timestamp created_at
    }

    ORDER_ITEM {
        uuid id PK
        uuid order_id FK
        uuid product_id FK
        int quantity
        decimal price
    }

    PRODUCT {
        uuid id PK
        string name
        decimal price
        int stock
    }

    USER ||--o{ ORDER : places
    ORDER ||--|{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : "included in"
```

---

## State Diagram

```mermaid
stateDiagram-v2
    [*] --> Draft

    Draft --> Pending : Submit
    Pending --> Approved : Approve
    Pending --> Rejected : Reject
    Rejected --> Draft : Edit
    Approved --> Published : Publish
    Published --> Archived : Archive

    Archived --> [*]

    note right of Pending : Awaiting review
    note right of Published : Visible to users
```

---

## Gantt Chart

```mermaid
gantt
    title Project Timeline
    dateFormat YYYY-MM-DD

    section Planning
    Requirements     :done, req, 2024-01-01, 7d
    Design           :done, des, after req, 5d

    section Development
    Backend API      :active, api, after des, 14d
    Frontend UI      :ui, after des, 14d
    Integration      :int, after api, 7d

    section Testing
    Unit Tests       :test1, after api, 5d
    E2E Tests        :test2, after int, 5d

    section Deployment
    Staging          :stage, after test2, 2d
    Production       :prod, after stage, 1d
```

---

## Pie Chart

```mermaid
pie showData
    title Technology Stack Distribution
    "TypeScript" : 45
    "Python" : 30
    "Go" : 15
    "Other" : 10
```

---

## Usage Tips

1. **Keep it simple** — Diagrams should clarify, not complicate
2. **Use consistent naming** — Match names to actual code/components
3. **Add notes** — Explain non-obvious relationships
4. **Version control** — Store diagram source with code
5. **Validate syntax** — Use Mermaid Live Editor to test
