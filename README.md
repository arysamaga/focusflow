# FocusFlow

**Author:** Aryan Samaga  
**UMID:** 64440397

## Overview

FocusFlow is a personal coursework planning application built with Jac. It helps students organize assignments, deadlines, courses, priorities, notes, and completion status in one place.

The project includes four components:

- A persistent Jac server/backend
- A browser-based web frontend
- A mobile client target
- A command-line interface (CLI)

The main web and mobile clients use the same FocusFlow planning application and server-side task model. Planning data is stored persistently by the Jac backend so tasks can remain available across server sessions.

---

## Features

### Planning and Tasks

FocusFlow tasks support:

- Task title
- Course
- Due date
- Priority
- Notes
- Completion status

Users can:

- Add tasks
- View tasks
- Mark tasks as complete
- Delete tasks
- Filter tasks
- Track active and completed work
- View high-priority task counts

### Dashboard

The web interface includes dashboard statistics for:

- Active tasks
- Completed tasks
- High-priority tasks

The interface also provides filters to make it easier to focus on relevant coursework.

### Persistent Planning Data

The main FocusFlow server stores tasks using Jac graph nodes.

Tasks are represented by the `Task` node, while public walkers provide planning operations such as:

- `AddTask`
- `ListTasks`
- `CompleteTask`
- `DeleteTask`

Because the planning data is managed by the Jac server, tasks persist across server restarts.

---

## Architecture

FocusFlow is organized around a shared Jac backend.

```text
                     FocusFlow
                         |
                 Jac Server / API
                         |
                 Persistent Task Graph
                         |
                  Public Jac Walkers
                         |
              +----------+----------+
              |                     |
         Web Client             Mobile Client
         `jac run`          `--client mobile`
              |                     |
              +---- Shared Data ----+

                     CLI
                      |
             Terminal task workflow
```

### Server

The server-side planning model is defined in:

```text
endpoints.sv.jac
```

The server defines the persistent `Task` node and walkers for creating, listing, completing, and deleting tasks.

### Web Frontend

The main browser interface is implemented with:

```text
frontend.cl.jac
frontend.impl.jac
main.jac
```

The frontend invokes the server walkers to work with persistent planning data.

### Mobile

FocusFlow uses Jac's official mobile client target.

Instead of maintaining a separate copy of the planner, the mobile target builds the main FocusFlow application for a mobile environment. This allows the mobile client to use the same planning interface, server-side walkers, and persistent task data as the web client.

This approach keeps the web and mobile versions integrated rather than maintaining separate planning databases.

### CLI

The CLI is located in:

```text
cli/main.jac
```

It provides a fast terminal-oriented workflow for common planning actions.

---

## Project Structure

```text
focusflow/
├── main.jac
├── endpoints.sv.jac
├── frontend.cl.jac
├── frontend.impl.jac
├── mobile.cl.jac
├── mobile.impl.jac
├── jac.toml
├── README.md
├── cli/
│   └── main.jac
├── components/
└── mobile/
```

Jac's mobile setup may also generate native mobile project files for Android and iOS.

---

## Requirements

The project was developed using Jac and the `jac-client` plugin.

The main requirements are:

- Python
- Jac
- `jac-client`
- Bun / JavaScript dependencies used by the Jac client tooling

Install `jac-client` if it is not already available:

```bash
python -m pip install jac-client
```

Verify Jac:

```bash
jac --version
```

---

# Running FocusFlow

## Web Application and Server

From the repository root, run:

```bash
jac run
```

The root `jac.toml` configures `main.jac` as the project entry point, so this starts the FocusFlow full-stack application.

Open the local URL printed by Jac in a browser.

The web application can then be used to:

1. Add coursework tasks
2. Assign courses and due dates
3. Set priorities
4. Add notes
5. Mark work complete
6. Delete tasks
7. Filter tasks
8. View planning statistics

---

## Mobile Client

FocusFlow supports Jac's official mobile client target.

### Initial mobile setup

The first time the mobile target is used, run:

```bash
jac setup mobile
```

The project contains mobile configuration in `jac.toml`:

```toml
[plugins.client.mobile]
app_name = "Focus Flow"
app_id = "com.focusflow.app"
```

### Start the mobile development target

From the repository root:

```bash
jac start main.jac --dev --client mobile --platform auto --port 8100
```

The explicit port is useful if the default development port is already being used by another process.

During development, Jac compiles the client for its mobile target while running the FocusFlow application and backend.

The mobile target uses the main FocusFlow application rather than a separate planning database. As a result, the mobile interface works with the same server-side planning model used by the web application.

### Native Android Setup

Building or deploying the application to an Android device/emulator additionally requires native Android development tools, including:

- A JDK compatible with the installed mobile tooling
- Android SDK
- Android platform tools / ADB
- Android Studio or equivalent command-line Android tooling

These are platform prerequisites rather than FocusFlow application dependencies.

For development environments without the native Android SDK configured, Jac can still compile the FocusFlow client for the mobile development target, but native Android deployment requires the Android toolchain.

### iOS

Native iOS development requires the appropriate Apple/Xcode tooling on macOS.

---

# Command-Line Interface

FocusFlow also includes a CLI for quick planning actions from a terminal.

The CLI can be run from the repository root.

## Help

```bash
jac run cli/main.jac help
```

## Add a Task

```bash
jac run cli/main.jac add "Finish homework"
```

Optional course, due date, and priority values can also be supplied:

```bash
jac run cli/main.jac add "Study for exam" "ECON 409" "2026-10-08" "high"
```

## List Tasks

```bash
jac run cli/main.jac list
```

## Today's Plan

```bash
jac run cli/main.jac today
```

This provides a quick terminal view of unfinished tasks relevant to the current date.

## Mark a Task Complete

First list the tasks:

```bash
jac run cli/main.jac list
```

Copy the task ID and run:

```bash
jac run cli/main.jac done TASK_ID
```

## Statistics

```bash
jac run cli/main.jac stats
```

This reports:

- Total tasks
- Completed tasks
- Remaining tasks

---

# Server API and Planning Logic

The main server is implemented in `endpoints.sv.jac`.

## Task Node

Each planning task contains:

```text
title
course
due
priority
notes
completed
```

## AddTask

Creates a new persistent task.

## ListTasks

Traverses the task graph and reports stored tasks.

## CompleteTask

Finds a task using its Jac ID and marks it complete.

## DeleteTask

Finds a task using its Jac ID and deletes it.

These walkers provide the server-side planning functionality used by the main FocusFlow client.

---

# Persistence

FocusFlow uses Jac's graph-based server data model for its main application.

A task is connected to the root graph when it is created. The application can later traverse those nodes through `ListTasks`.

This means coursework entered into the main planner is not limited to temporary frontend state.

Persistence was tested by creating tasks, restarting the server, and confirming that the stored tasks were still available.

---

# Fresh Checkout Instructions

To test FocusFlow from a fresh checkout:

```bash
git clone <repository-url>
cd focusflow
```

Make sure Jac and the client plugin are installed:

```bash
jac --version
python -m pip install jac-client
```

Then start the main application:

```bash
jac run
```

The server and web frontend should start from the repository root.

Create a task in the web interface and verify that it appears in the dashboard.

For mobile development, perform the mobile setup if necessary:

```bash
jac setup mobile
```

Then run:

```bash
jac start main.jac --dev --client mobile --platform auto --port 8100
```

Native Android/iOS deployment additionally requires the corresponding platform development tools described above.

The CLI can be tested with:

```bash
jac run cli/main.jac help
jac run cli/main.jac add "Fresh checkout CLI test"
jac run cli/main.jac list
jac run cli/main.jac today
jac run cli/main.jac stats
```

---

# Verification

The project can be checked with:

```bash
jac check .
```

The main workflows to verify are:

### Web

```bash
jac run
```

Then:

- Create a task
- View it in the task list
- Mark it complete
- Delete a task
- Test the filters and statistics

### Persistence

- Create a task
- Stop the server
- Restart with `jac run`
- Confirm that the task remains available

### Mobile Target

```bash
jac start main.jac --dev --client mobile --platform auto --port 8100
```

Confirm that Jac compiles the client for mobile development and starts the FocusFlow application/backend.

### CLI

```bash
jac run cli/main.jac help
jac run cli/main.jac add "CLI verification"
jac run cli/main.jac list
jac run cli/main.jac today
jac run cli/main.jac stats
```

---

# Design Decisions

## Shared Web and Mobile Planning Application

FocusFlow intentionally uses the same core planning application for web and mobile targets.

This provides several benefits:

- A consistent user experience
- Shared server-side planning logic
- Shared persistent task data
- Less duplicated frontend logic
- Easier maintenance
- Better integration between components

The mobile version therefore does not maintain an unrelated task store or duplicate backend.

## Jac Walkers as Planning Operations

Planning actions are implemented as Jac walkers rather than keeping all application behavior in frontend state.

This separates the persistent planning logic from the user interface.

## Coursework-Focused Data Model

The planner is designed specifically for student coursework rather than being a generic to-do list.

Course, due date, priority, notes, and completion status make each task useful for academic planning.

## Dashboard Statistics

The dashboard calculates useful high-level planning information so a student can quickly see how much work remains and whether high-priority tasks need attention.

## CLI Workflow

The CLI provides a second style of interaction for users who want to quickly inspect or manage planning information without opening a graphical interface.

---

# Notable / Impressive Aspects

FocusFlow goes beyond a minimal single-page task list in several ways:

- Persistent planning data using Jac graph nodes
- Server-side task operations implemented with walkers
- Full-stack Jac web interface
- Official Jac mobile client target
- Shared main planning application between web and mobile
- Coursework-specific task metadata
- Priority tracking
- Completion tracking
- Dashboard statistics
- Task filtering
- Terminal planning workflow
- Fresh-checkout-friendly root configuration

The project demonstrates how Jac can be used across server logic, persistent data, browser interfaces, mobile targets, and command-line workflows within one planning application.

---

# Technologies

- Jac
- Jac graph nodes and walkers
- Jac client/full-stack tooling
- React-based Jac client compilation
- Jac mobile target / Capacitor tooling
- Bun
- Git / GitHub

---

# Summary

FocusFlow is a personal coursework planner built around Jac.

Its main server stores persistent planning tasks and exposes planning operations through Jac walkers. The browser frontend provides a dashboard for managing coursework, while Jac's mobile client target allows the same integrated planning application to be built for mobile development. A CLI provides additional terminal-based planning actions.

Together, these components provide multiple ways to interact with a student's planning workflow while demonstrating server, web, mobile, persistent-data, and CLI capabilities in Jac.
