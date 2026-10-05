"""FocusFlow - Personal Coursework Planner."""

import from endpoints {
    Task,
    AddTask,
    ListTasks,
    CompleteTask,
    DeleteTask
}

cl {
    import from .frontend { app as ClientApp }

    def:pub app -> JsxElement {
        return <ClientApp/>;
    }
}
