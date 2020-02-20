import 'package:flutter/material.dart';
import 'package:mentor_tracking/model.dart';
import 'package:provider/provider.dart';
import 'package:mentor_tracking/route/addActivityRecord.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class MenteeActivityListRoute extends StatelessWidget {
  final String menteeId;

  MenteeActivityListRoute(this.menteeId);

  void _addActivity(ActivityRecord record, MenteeModel model) {
    if (record != null) {
      model.addActivityRecordForMentee(menteeId, record);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenteeModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("CET Mentor Tracking App"),
          ),
          body: Center(
            child: ListView.builder(
              itemCount: model.activityRecordsForMenteeId(menteeId).length,
              itemBuilder: (BuildContext context, int index) {
                final record =
                model.activityRecordsForMenteeId(menteeId)[index];

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.event_note,
                        color: record.hasFlag == true? Colors.green : Colors.grey,),
                      title: Text('${record.minutesSpent} mins - ${record.notes}'),
                      onLongPress: () async {
                        _addActivity(
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddActivityRecordRoute(
                                    model.menteeForMenteeId(menteeId), record)),
                          ),
                          model,
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
                      icon: Icons.create,
                      color: Colors.indigo,
                      onTap: () async {
                        _addActivity(
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddActivityRecordRoute(
                                    model.menteeForMenteeId(menteeId), record)),
                          ),
                          model,
                        );
                      },
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: () => model.deleteActivityRecord(menteeId, record.id),
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              _addActivity(
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddActivityRecordRoute(
                          model.menteeForMenteeId(menteeId))),
                ),
                model,
              );
            },
            tooltip: 'Add Activity Record',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
