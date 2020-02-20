# mentor_tracking

A mentor tracking app that lets mentors track and report their interactions with mentees.
Each year the CET needs to report on volunteer hours donated and otherwise generally manage the mentoring program.
This app will help mentors manage their mentoring work and report to the CET more easily.


Features
- Your app should let a mentor create and manage a list of students s/he is mentoring, including name, cell phone, and email address.  Support the typical CRUD operations for this list.
- Design a user experience for the mentor to tap on a student and report a mentoring experience.  The mentor should be able to indicate date (default to today), amount of time spent (default to 30 minutes), and any optional notes.
- For now, we will not save these records on a server.  Instead, attach the report record to the student, and allow the mentor to browse the list of reports for a given student.  Again, support the typical CRUD operations for the report list.
- Also let the mentor access a combined list of all reports for all students.


LEARNING EXPERIENCE
My biggest learning experience was state management. It's what I struggled with the most while starting this project.
This is how I learnt to use the provider package:
Extend Model Classes with ChangeNotifier. Call the onChange method whenever something changes in the model which might affect the UI and notifyListeners() will send a notification to all the listening widgets to rebuild.
ChangeNotifierProvider is the widget that provides an instance of a ChangeNotifier to its descendants. Wrap the immediate parent widget in the widget hierarchy whenever a child widget needs ChangeNotifierProvider.
To use the ChangeNotifierProvider, we need the Consumer Widget. We must specify the type of the model that we want to access. Instead of Consumer, we can also use provider.of

Now I feel like I have a good grasp and better understanding on the change notifier provider class.
Having done a real world business app helped soldify these concepts.

I also became more familiar with material UI design concepts like dialogs, snackbars, material icons, tooltips, buttons, etc. I also learnt how to implement them.

Another big learning point was model access. It definitely took me a good number of tries to understand how to access the model and manipulate with the data that was being created, updated or deleted.

I really enjoyed adding the slidable list item. There are directional slide actions that can be dismissed. After lots of trial and error, I was able to implement it for the delete and edit functionality.
