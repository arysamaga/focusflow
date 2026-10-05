"""FocusFlow coursework planner UI."""

sv import from endpoints {
    Task,
    AddTask,
    ListTasks,
    CompleteTask,
    DeleteTask
}

def:pub app -> JsxElement {
    has tasks: list[Task] = [],
        title: str = "",
        course: str = "",
        due: str = "",
        priority: str = "medium",
        notes: str = "";

    can with entry {
        loadTasks();
    }

    async def loadTasks -> None;
    async def addTask(e: FormEvent) -> None;
    async def completeTask(task_id: str) -> None;
    async def deleteTask(task_id: str) -> None;

    return
        <div style={{
            "maxWidth": "1000px",
            "margin": "0 auto",
            "padding": "32px 20px",
            "fontFamily": "system-ui, -apple-system, sans-serif",
            "color": "#172033"
        }}>
            <header style={{"marginBottom": "32px"}}>
                <h1 style={{
                    "fontSize": "42px",
                    "margin": "0",
                    "letterSpacing": "-1px"
                }}>
                    FocusFlow
                </h1>
                <p style={{
                    "color": "#64748b",
                    "fontSize": "17px",
                    "marginTop": "8px"
                }}>
                    Plan coursework. Prioritize what matters. Get it done.
                </p>
            </header>

            <div style={{
                "backgroundColor": "#f8fafc",
                "border": "1px solid #e2e8f0",
                "borderRadius": "16px",
                "padding": "24px",
                "marginBottom": "28px"
            }}>
                <h2 style={{"marginTop": "0"}}>Add coursework</h2>

                <form onSubmit={addTask}>
                    <div style={{
                        "display": "grid",
                        "gridTemplateColumns": "2fr 1fr",
                        "gap": "12px",
                        "marginBottom": "12px"
                    }}>
                        <input
                            type="text"
                            value={title}
                            onChange={lambda e: ChangeEvent {
                                title = e.target.value;
                            }}
                            placeholder="What do you need to do?"
                            required={True}
                            style={{
                                "padding": "12px",
                                "border": "1px solid #cbd5e1",
                                "borderRadius": "8px",
                                "fontSize": "15px"
                            }}
                        />

                        <input
                            type="text"
                            value={course}
                            onChange={lambda e: ChangeEvent {
                                course = e.target.value;
                            }}
                            placeholder="Course"
                            style={{
                                "padding": "12px",
                                "border": "1px solid #cbd5e1",
                                "borderRadius": "8px",
                                "fontSize": "15px"
                            }}
                        />
                    </div>

                    <div style={{
                        "display": "grid",
                        "gridTemplateColumns": "1fr 1fr",
                        "gap": "12px",
                        "marginBottom": "12px"
                    }}>
                        <input
                            type="date"
                            value={due}
                            onChange={lambda e: ChangeEvent {
                                due = e.target.value;
                            }}
                            style={{
                                "padding": "12px",
                                "border": "1px solid #cbd5e1",
                                "borderRadius": "8px"
                            }}
                        />

                        <select
                            value={priority}
                            onChange={lambda e: ChangeEvent {
                                priority = e.target.value;
                            }}
                            style={{
                                "padding": "12px",
                                "border": "1px solid #cbd5e1",
                                "borderRadius": "8px"
                            }}
                        >
                            <option value="low">Low priority</option>
                            <option value="medium">Medium priority</option>
                            <option value="high">High priority</option>
                        </select>
                    </div>

                    <input
                        type="text"
                        value={notes}
                        onChange={lambda e: ChangeEvent {
                            notes = e.target.value;
                        }}
                        placeholder="Notes (optional)"
                        style={{
                            "boxSizing": "border-box",
                            "width": "100%",
                            "padding": "12px",
                            "border": "1px solid #cbd5e1",
                            "borderRadius": "8px",
                            "marginBottom": "12px"
                        }}
                    />

                    <button
                        type="submit"
                        style={{
                            "backgroundColor": "#2563eb",
                            "color": "white",
                            "border": "none",
                            "borderRadius": "8px",
                            "padding": "12px 20px",
                            "fontWeight": "600",
                            "cursor": "pointer"
                        }}
                    >
                        Add Task
                    </button>
                </form>
            </div>

            <section>
                <div style={{
                    "display": "flex",
                    "justifyContent": "space-between",
                    "alignItems": "center"
                }}>
                    <h2>My coursework</h2>
                    <span style={{"color": "#64748b"}}>
                        {len(tasks)} tasks
                    </span>
                </div>

                {
                    [
                        <div
                            key={jid(task)}
                            style={{
                                "border": "1px solid #e2e8f0",
                                "borderRadius": "12px",
                                "padding": "18px",
                                "marginBottom": "12px",
                                "backgroundColor": "#ffffff",
                                "opacity": "0.55" if task.completed else "1"
                            }}
                        >
                            <div style={{
                                "display": "flex",
                                "justifyContent": "space-between",
                                "gap": "20px"
                            }}>
                                <div style={{"flex": "1"}}>
                                    <h3 style={{
                                        "margin": "0 0 6px 0",
                                        "textDecoration": "line-through" if task.completed else "none"
                                    }}>
                                        {task.title}
                                    </h3>

                                    <div style={{
                                        "fontSize": "14px",
                                        "color": "#64748b"
                                    }}>
                                        {task.course}
                                        {" · Due " + task.due if task.due else ""}
                                        {" · " + task.priority + " priority"}
                                    </div>

                                    {
                                        <p style={{
                                            "marginBottom": "0",
                                            "color": "#475569"
                                        }}>
                                            {task.notes}
                                        </p>
                                        if task.notes else <span></span>
                                    }
                                </div>

                                <div style={{
                                    "display": "flex",
                                    "gap": "8px",
                                    "alignItems": "center"
                                }}>
                                    {
                                        <button
                                            onClick={lambda {
                                                completeTask(jid(task));
                                            }}
                                            style={{
                                                "border": "none",
                                                "borderRadius": "7px",
                                                "padding": "9px 12px",
                                                "cursor": "pointer"
                                            }}
                                        >
                                            Done
                                        </button>
                                        if not task.completed else <span>✓</span>
                                    }

                                    <button
                                        onClick={lambda {
                                            deleteTask(jid(task));
                                        }}
                                        style={{
                                            "border": "none",
                                            "borderRadius": "7px",
                                            "padding": "9px 12px",
                                            "cursor": "pointer"
                                        }}
                                    >
                                        Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                        for task in tasks
                    ]
                }
            </section>
        </div>;
}
