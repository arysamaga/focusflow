"""FocusFlow shared mobile client behavior."""

impl mobile_app.loadTasks -> None {
    result = root spawn ListTasks();
    tasks = result.reports;
}
