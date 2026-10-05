"""FocusFlow server-side planning data and API."""

node Task {
    has title: str,
        course: str = "General",
        due: str = "",
        priority: str = "medium",
        notes: str = "",
        completed: bool = False;
}

walker:pub AddTask {
    has title: str,
        course: str = "General",
        due: str = "",
        priority: str = "medium",
        notes: str = "",
        reports: list[Task] = [];

    can add with Root entry {
        report (here ++> Task(
            title=self.title,
            course=self.course,
            due=self.due,
            priority=self.priority,
            notes=self.notes
        ))[0];
    }
}

walker:pub ListTasks {
    has reports: list[Task] = [];

    can collect with Root entry {
        visit [-->];
    }

    can gather with Task entry {
        report here;
    }
}

walker:pub CompleteTask {
    has task_id: str,
        reports: list[Task] = [];

    can find with Root entry {
        visit [-->];
    }

    can complete with Task entry {
        if jid(here) == self.task_id {
            here.completed = True;
            report here;
        }
    }
}

walker:pub DeleteTask {
    has task_id: str;

    can find with Root entry {
        visit [-->];
    }

    can remove with Task entry {
        if jid(here) == self.task_id {
            del here;
        }
    }
}
