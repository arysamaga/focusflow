"""FocusFlow mobile coursework planner."""

cl import from .components.Button { Button }

cl def:pub app -> JsxElement {
    has completed_today: int = 0;

    return
        <div style={{"padding": "2rem", "fontFamily": "Arial, sans-serif"}}>
            <h1>FocusFlow Mobile</h1>

            <p>
                Quick coursework progress tracker
            </p>

            <h2>Today's Progress</h2>

            <p>
                Tasks completed today:{completed_today}
            </p>

            <div style={{"display": "flex", "gap": "1rem", "marginTop": "1rem"}}>
                <Button
                    label="Complete Task"
                    onClick={lambda {
                        completed_today = completed_today + 1;
                    }}
                    variant="primary"
                />

                <Button
                    label="Reset Today"
                    onClick={lambda {
                        completed_today = 0;
                    }}
                    variant="secondary"
                />
            </div>
        </div>;
}
