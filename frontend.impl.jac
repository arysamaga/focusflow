"""FocusFlow client behavior."""

impl app.loadTasks -> None {
    result = root spawn ListTasks();
    tasks = result.reports;
}

impl app.addTask(e: FormEvent) -> None {
    e.preventDefault();

    if not title.strip() {
        return;
    }

    result = root spawn AddTask(
        title=title,
        course=course if course.strip() else "General",
        due=due,
        priority=priority,
        notes=notes
    );

    tasks = tasks + [result.reports[0]];

    title = "";
    course = "";
    due = "";
    priority = "medium";
    notes = "";
}

impl app.completeTask(task_id: str) -> None {
    root spawn CompleteTask(task_id=task_id);
    loadTasks();
}

impl app.deleteTask(task_id: str) -> None {
    root spawn DeleteTask(task_id=task_id);
    loadTasks();
}