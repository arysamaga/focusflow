# FocusFlow

**Name:** Aryan Samaga  
**UMID:** XXXXXXXX

## Description

FocusFlow is a personal coursework planning application built with Jac. It is designed to help students organize assignments, deadlines, priorities, notes, and coursework progress.

The project contains all four required application components:

1. A persistent Jac server
2. A browser-based web frontend
3. A mobile-oriented interface connected to the same planning backend
4. A Jac command-line interface (CLI)

The main web application is intended for planning and managing coursework, the mobile interface provides a lightweight way to check planning information, and the CLI provides quick terminal-based planning actions.

---

## Features

### Persistent Planning Server

FocusFlow uses Jac nodes and walkers to implement the main planning backend.

Each `Task` stores:

- Title
- Course
- Due date
- Priority
- Notes
- Completion status

The server provides the following Jac walkers:

- `AddTask`
- `ListTasks`
- `CompleteTask`
- `DeleteTask`

Tasks are represented as persistent Jac graph nodes, allowing planning data to remain available between application sessions.

---

### Web Frontend

The browser interface provides the primary coursework planning experience.

Users can:

- Add coursework tasks
- Associate tasks with courses
- Set due dates
- Select low, medium, or high priority
- Add optional notes
- Mark tasks complete
- Delete tasks
- Filter between all, active, and completed tasks
- View planning statistics

The dashboard displays:

- Number of active tasks
- Number of completed tasks
- Number of active high-priority tasks

The web frontend communicates with the Jac server through the planning walkers rather than maintaining a separate browser-only task list.

---

### Mobile Interface

FocusFlow also provides a lightweight mobile-oriented client interface.

The shared mobile interface is implemented in:

```text
mobile.cl.jac
mobile.impl.jac
```

It uses the same server-side `Task` model and `ListTasks` walker used by the main web application.

This means coursework created in the main planner can also be retrieved through the mobile interface from the same persistent planning backend.

When the main application is running, the mobile client is exposed through the `mobile` client route.

For example, if the API server is running on port 8001:

```text
http://localhost:8001/cl/mobile
```

Use the actual API port printed by `jac run` because Jac may select a different port if the default port is already occupied.

The repository also contains the standalone `mobile/` Jac client project, which provides a small coursework progress interface and demonstrates Jac client/mobile component structure.

To run the standalone mobile client:

```bash
cd mobile
jac start main.jac
```

---

### Command-Line Interface

FocusFlow includes a Jac command-line planning interface for quick terminal workflows.

Available actions include:

- Add a task
- List tasks
- View today's plan
- Mark a task complete
- View planning statistics

Display CLI help:

```bash
jac run cli/main.jac help
```

Add a task:

```bash
jac run cli/main.jac add "Study for Midterm" EECS 2026-10-10 high
```

List tasks:

```bash
jac run cli/main.jac list
```

View today's plan:

```bash
jac run cli/main.jac today
```

Mark a task complete:

```bash
jac run cli/main.jac done TASK_ID
```

View statistics:

```bash
jac run cli/main.jac stats
```

The CLI uses persistent Jac graph data for its terminal planning workflow.

---

## Setup and Prerequisites

This project was developed and tested with:

- Jac Language 0.16.7
- Python / Conda
- `jac-client`
- A modern web browser

Verify Jac is installed:

```bash
jac --version
```

If the Jac client plugin is not installed in the Python environment used by Jac, install it with:

```bash
python -m pip install jac-client
```

---

## Running the Main Application

From a fresh checkout, enter the repository root and run:

```bash
jac run
```

This is the default project entry point and starts the FocusFlow server and browser client.

Jac prints the actual URLs when startup completes. For example:

```text
App: http://localhost:8000/
API: http://localhost:8001/
```

If one of those ports is already occupied, Jac automatically chooses another available port. Always use the `App:` and `API:` addresses printed in the terminal.

Open the `App:` URL in a browser to use the main FocusFlow web planner.

Stop the application with:

```text
Ctrl+C
```

---

## Running in Development Mode

The application can also be started with file watching and hot module reloading:

```bash
jac start --dev
```

---

## Running the Shared Mobile Interface

First start the main FocusFlow application from the repository root:

```bash
jac run
```

Find the API URL printed by Jac.

Then open:

```text
<API URL>/cl/mobile
```

For example:

```text
http://localhost:8001/cl/mobile
```

The mobile route retrieves tasks using the same `ListTasks` walker and persistent `Task` data as the main web application.

A task created through the web planner can therefore be viewed through this mobile interface.

---

## Running the Standalone Mobile Client

The repository also includes a standalone Jac mobile/client project.

Run:

```bash
cd mobile
jac start main.jac
```

Jac will compile the client and print the local address where it can be opened.

To check the mobile source without starting it:

```bash
cd mobile
jac check main.jac
```

---

## Running the CLI

Run CLI commands from the repository root.

Help:

```bash
jac run cli/main.jac help
```

Example workflow:

```bash
jac run cli/main.jac add "Finish statistics homework" Mathematics 2026-10-06 high
jac run cli/main.jac list
jac run cli/main.jac today
jac run cli/main.jac stats
```

The `add` command prints the task ID. That ID can be used to complete the task:

```bash
jac run cli/main.jac done TASK_ID
```

---

## Project Architecture

The main project is organized around Jac's server/client model.

```text
focusflow/
├── jac.toml
├── main.jac
├── endpoints.sv.jac
├── frontend.cl.jac
├── frontend.impl.jac
├── mobile.cl.jac
├── mobile.impl.jac
├── components/
├── cli/
│   └── main.jac
├── mobile/
│   ├── jac.toml
│   ├── main.jac
│   └── components/
└── README.md
```

### Server Layer

`endpoints.sv.jac` contains the persistent planning data model and server-side walkers.

The central node is:

```text
Task
```

The server operations are:

```text
AddTask
ListTasks
CompleteTask
DeleteTask
```

### Web Layer

`frontend.cl.jac` defines the primary browser interface and client-side application state.

`frontend.impl.jac` implements behavior that invokes the server walkers.

For example, loading tasks follows the general flow:

```text
Web UI
   |
   v
ListTasks walker
   |
   v
Persistent Task graph
```

### Mobile Layer

`mobile.cl.jac` defines the shared mobile-oriented client interface.

`mobile.impl.jac` invokes `ListTasks` against the same backend used by the web application.

The resulting architecture is:

```text
                 Persistent Task Graph
                          |
                    Server Walkers
                          |
              +-----------+-----------+
              |                       |
        Web Frontend             Mobile Client
              |                       |
          ListTasks                 ListTasks
              |                       |
              +-----------+-----------+
                          |
                    Same Task Data
```

### CLI Layer

`cli/main.jac` provides terminal-oriented planning functionality including adding tasks, listing tasks, viewing today's plan, completing tasks, and viewing statistics.

The CLI provides a fast alternative workflow for planning from the terminal.

---

## How the Components Work Together

FocusFlow uses different interfaces for different planning workflows.

The **server** provides persistent planning data and the core task operations.

The **web frontend** provides the most complete planning interface for creating, organizing, completing, filtering, and deleting coursework.

The **shared mobile interface** uses the same server-side `Task` model and `ListTasks` walker, allowing the user to retrieve the same coursework data from a lightweight interface.

The **CLI** provides quick planning actions from the terminal.

Together, these components provide multiple ways to interact with the FocusFlow coursework-planning system while keeping the primary planning logic implemented in Jac.

---

## Persistence

The main web/server planning system stores tasks as Jac graph nodes.

Planning data was verified to remain available after stopping and restarting the application.

For example, previously created coursework was successfully retrieved after restarting the server through the `ListTasks` walker.

The CLI also maintains persistent Jac planning data for its terminal workflow.

---

## Validation

The complete project can be checked from the repository root with:

```bash
jac check .
```

During final testing, all Jac source files passed the Jac checker.

The CLI can be checked individually with:

```bash
jac check cli/main.jac
```

The standalone mobile application can be checked with:

```bash
cd mobile
jac check main.jac
```

The shared mobile client can be checked from the root with:

```bash
jac check mobile.cl.jac
```

---

## Fresh Checkout Verification

The project is configured so the main application can be started from the repository root with:

```bash
jac run
```

This command was verified to:

1. Compile the Jac client
2. Start the Jac API server
3. Start the browser frontend
4. Serve the FocusFlow application
5. Load persistent planning data

No source-code modifications are required after checkout before starting the main application, assuming the prerequisites are installed.

---

## Notable / Impressive Aspects

FocusFlow goes beyond a minimal static task list by using Jac's graph and walker model for a persistent full-stack planning application.

Notable features include:

- Persistent graph-based coursework storage
- Jac server walkers for task operations
- Full browser-based task management
- Shared web and mobile access to persistent task data
- Course organization
- Due-date tracking
- Priority tracking
- Optional task notes
- Completion tracking
- Task deletion
- Active/completed filtering
- Dashboard statistics
- High-priority task metrics
- Terminal planning workflow
- Mobile-oriented planning interface
- Responsive web interface
- Root-level `jac run` startup
- Jac-first project architecture

The project demonstrates server-side Jac, client-side Jac, persistent graph data, walker-based APIs, browser UI development, mobile-oriented UI development, and command-line interaction within one personal planning project.

---

## Author

**Aryan Samaga**  
**UMID:** 64440397
