import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';
import 'package:mentor_tracking/dialog/addMentee.dart';
import 'menteeActivity.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mentor_tracking/route/addActivityRecord.dart';
import 'package:intl/intl.dart';

class MainAppRoute extends StatefulWidget {
  MainAppRoute({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainAppRouteState createState() => _MainAppRouteState();
}

class _MainAppRouteState extends State<MainAppRoute> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widgetForCurrentState(MenteeModel model) {
    return (_selectedIndex <= 0)
        ? Scrollbar(
      child: ListView.builder(
        itemCount: model.mentees.length,
        itemBuilder: (BuildContext context, int index) {
          final mentee = model.mentees[index];

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Card(
              child: ListTile(
                leading: Icon(Icons.person,
                  color: model.mentees[index].hasFlag == true? Colors.green : Colors.grey,),
                title: Text('${mentee.firstName} ${mentee.lastName}'),
                subtitle: Text('${mentee.cellPhone} ${mentee.email}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MenteeActivityListRoute(mentee.id)),
                  );
                },
                onLongPress: () async {
                  var editedMentee = await addOrEditMenteeDialog(context, mentee);

                  if (editedMentee != null) {
                    model.editMentee(editedMentee);
                  }
                },
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                caption: model.mentees[index].hasFlag == true? 'Unflag' : 'Flag',
                icon: Icons.flag,
                color: Colors.green,
                onTap: () => model.setFlagMentee(model.mentees[index]),
              ),
              IconSlideAction(
                caption: 'Edit',
                icon: Icons.create,
                color: Colors.indigo,
                onTap: () async {
                  var editedMentee = await addOrEditMenteeDialog(context, mentee);

                  if (editedMentee != null) {
                    model.editMentee(editedMentee);
                  }
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'More',
                icon: Icons.more_horiz,
                color: Colors.black45,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MenteeActivityListRoute(mentee.id)),
                  );
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                icon: Icons.delete,
                color: Colors.red,
                onTap: () => model.deleteMentee(model.mentees[index]),
              ),
            ],
          );
        },
      ),
    )
        : Scrollbar(
        child: ListView.builder(
          itemCount: model.activityRecords.length,
          itemBuilder: (BuildContext context, int index) {
            final record = model.activityRecords[index];
            var formatter = new DateFormat("MMMM d");

            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.event_note,
                    color: model.activityRecords[index].hasFlag == true? Colors.green : Colors.grey,),
                  title: Text('${formatter.format(record.date)}'),
                  subtitle: Text('${record.minutesSpent} mins - ${record.notes}'),
                  onLongPress: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddActivityRecordRoute(
                              model.menteeForMenteeId(record.menteeId), record)),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: record.hasFlag == true? 'Unflag' : 'Flag',
                  icon: Icons.flag,
                  color: Colors.green,
                  onTap: () => model.setFlagRecord(record.id),
                ),
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.indigo,
                  icon: Icons.create,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddActivityRecordRoute(
                              model.menteeForMenteeId(record.menteeId), record)),
                    );
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => model.deleteActivityRecord(record.menteeId, record.id),
                ),
              ],
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<MenteeModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: _widgetForCurrentState(model),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Mentees'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text('Activity'),
            ),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Colors.amber[300],
          onTap: _onItemTapped,
        ),
        floatingActionButton: _selectedIndex == 0? FloatingActionButton(
          onPressed: () async {
            var mentee = await addOrEditMenteeDialog(context);

            if (mentee != null) {
              model.addMentee(mentee);
            }
          },
          tooltip: 'Add Mentee',
          child: Icon(Icons.add),
        ) : null, // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}