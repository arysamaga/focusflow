"""FocusFlow mobile interface using the shared backend."""

sv import from endpoints {
    Task,
    ListTasks,
    CompleteTask
}

def:pub mobile_app -> JsxElement {
    has tasks: list[Task] = [];

    can with entry {
        loadTasks();
    }

    async def loadTasks -> None;

    return
        <div style={{"padding": "2rem", "fontFamily": "Arial, sans-serif"}}>
            <h1>FocusFlow Mobile</h1>
            <p>Shared coursework planner</p>

            <h2>My Tasks</h2>

            <p>
                Total tasks:{len(tasks)}
            </p>

            <div>
                {[
                    <div
                        style={{
                            "padding": "1rem",
                            "marginBottom": "1rem",
                            "border": "1px solid #ddd",
                            "borderRadius": "8px"
                        }}
                    >
                        <strong>{task.title}</strong>
                        <p>{task.course}</p>
                        <p>{task.due}</p>
                    </div>
                    for task in tasks
                ]}
            </div>
        </div>;
}
