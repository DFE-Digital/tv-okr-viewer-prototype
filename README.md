# TVS OKR Roadmap Viewer

Internal prototype for the Teaching Vacancies Service.

The application provides an interactive OKR roadmap with objectives, key results, workstreams, activities and sprint-based scheduling.

## Current architecture

The application currently runs as three components:

```text
Browser
  ↓
Nginx frontend
  ↓
Node / Express API
  ↓
PostgreSQL
```

The frontend calls the API using relative `/api/...` paths. Nginx proxies these requests to the API service.

PostgreSQL is the source of truth for roadmap activity data.

## Current functionality

The viewer currently supports:

- loading roadmap activities from PostgreSQL
- creating activities
- editing activities
- deleting activities
- changing activity status
- changing start and end sprints
- changing duration by dragging on the timeline
- autosaving changes to PostgreSQL
- CSV and JSON export

An embedded copy of the original roadmap data remains in `index.html` as a fallback if the API is unavailable.

## Project structure

```text
TVS Roadmap Viewer
├── .env.example
├── .gitignore
├── Dockerfile
├── index.html
├── nginx.conf
├── README.md
└── api
    ├── Dockerfile
    ├── import_v11_3_activities.sql
    ├── package.json
    └── server.js
```

`.env` is used for local development and is deliberately excluded from Git.

## Local prerequisites

The current local setup has been tested on Windows using:

- WSL2
- Podman
- Podman Desktop

Docker-compatible container tooling should also work.

## Local configuration

Copy:

```text
.env.example
```

to:

```text
.env
```

and provide a local PostgreSQL password.

Example:

```text
POSTGRES_HOST=tvs-roadmap-postgres
POSTGRES_PORT=5432
POSTGRES_DB=tvs_roadmap
POSTGRES_USER=tvs_roadmap
POSTGRES_PASSWORD=replace-with-local-password
```

Do not commit `.env`.

## Local containers

The three containers currently used are:

```text
tvs-roadmap-postgres
tvs-roadmap-api-test
tvs-roadmap-test
```

They use the Podman network:

```text
tvs-roadmap-network
```

The local startup dependency is:

```text
PostgreSQL
↓
API
↓
Frontend
```

## Local URLs

Frontend:

```text
http://localhost:8080
```

API health check:

```text
http://localhost:3000/health/database
```

The browser itself no longer depends on port 3000. Frontend API calls use `/api/...` and are proxied by Nginx.

## Database

The PostgreSQL database is:

```text
tvs_roadmap
```

The activity table currently stores:

- id
- objective
- key result
- workstream
- activity
- start sprint
- end sprint
- status
- delivery link
- dependency
- schedule basis

The original v11.3 roadmap activities can be loaded using:

```text
api/import_v11_3_activities.sql
```

## Current data model limitation

Objectives, key results and workstreams are currently represented as attributes of activities rather than as separate database entities.

For longer-term use, the recommended model is:

```text
Planning cycle
  ↓
Objective
  ↓
Key Result
  ↓
Activity
      ↘ Workstream
```

Objectives, key results and workstreams should eventually have their own IDs and active/archive states.

This would support:

- future financial years
- adding or retiring objectives
- adding or editing key results
- historical roadmap views
- renaming entities without updating every activity record

## Concurrency

The current application uses a simple last-write-wins model.

Multiple users can read from the same database, but no optimistic locking or conflict warning has yet been implemented.

This is acceptable for initial internal testing but should be reviewed before wider rollout.

## Deployment considerations

The application has not yet been deployed into the Teacher Services Cloud environment.

The intended hosting model is:

- frontend container
- API container
- Azure-managed PostgreSQL
- Kubernetes / AKS
- secrets managed outside source control
- a single application hostname with `/api/*` routed to the API

Infrastructure decisions still required include:

- repository location
- Terraform
- managed PostgreSQL provisioning
- Kubernetes deployment configuration
- secrets management
- authentication / access control
- monitoring and logging
- backup and restore
- CI/CD
- production/non-production routing

## Security

The application currently has no authentication layer of its own.

It should not be exposed beyond an appropriately controlled internal environment until authentication and access controls have been agreed.

Secrets must not be committed to Git.

## Status

The local prototype is working end-to-end with PostgreSQL persistence and autosave.

The next stage is infrastructure review and deployment into a non-production Teacher Services environment.