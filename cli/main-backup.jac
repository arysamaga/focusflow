"""FocusFlow command-line interface."""

import from sys { argv }
import from datetime { date }

node CliTask {
    has title: str,
        course: str = "General",
        due: str = "",
        priority: str = "medium",
        completed: bool = False;
}

with entry {
    args = argv[1:];

    if len(args) == 0 or args[0] == "help" {
        print("FocusFlow CLI");
        print("");
        print("Commands:");
        print("  jac run cli/main.jac add \"Task\" [course] [due] [priority]");
        print("  jac run cli/main.jac list");
        print("  jac run cli/main.jac today");
        print("  jac run cli/main.jac done TASK_ID");
        print("  jac run cli/main.jac stats");

    } elif args[0] == "add" {
        if len(args) < 2 {
            print("Usage: add \"Task title\" [course] [due] [priority]");
        } else {
            task = CliTask(
                title=args[1],
                course=args[2] if len(args) > 2 else "General",
                due=args[3] if len(args) > 3 else "",
                priority=args[4] if len(args) > 4 else "medium"
            );

            root ++> task;

            print("Added:", task.title);
            print("ID:", jid(task));
        }

    } elif args[0] == "list" {
        tasks = [root -->][?:CliTask];

        if len(tasks) == 0 {
            print("No tasks yet.");
        }

        for task in tasks {
            print(
                "DONE" if task.completed else "TODO",
                jid(task),
                "|",
                task.course,
                "|",
                task.title,
                "| due:",
                task.due if task.due else "none",
                "|",
                task.priority
            );
        }

    } elif args[0] == "today" {
        today = str(date.today());
        tasks = [root -->][?:CliTask];

        print("FocusFlow Today -", today);

        for task in tasks {
            if not task.completed and (
                task.due == "" or task.due <= today
            ) {
                print(
                    jid(task),
                    "|",
                    task.course,
                    "|",
                    task.title,
                    "| due:",
                    task.due if task.due else "none"
                );
            }
        }

    } elif args[0] == "done" {
        if len(args) < 2 {
            print("Usage: done TASK_ID");
        } else {
            found = False;

            for task in [root -->][?:CliTask] {
                if jid(task) == args[1] {
                    task.completed = True;
                    found = True;
                    print("Completed:", task.title);
                }
            }

            if not found {
                print("Task not found.");
            }
        }

    } elif args[0] == "stats" {
        tasks = [root -->][?:CliTask];
        completed = len([task for task in tasks if task.completed]);

        print("FocusFlow Stats");
        print("Total:", len(tasks));
        print("Completed:", completed);
        print("Remaining:", len(tasks) - completed);

    } else {
        print("Unknown command.");
        print("Run: jac run cli/main.jac help");
    }
}
