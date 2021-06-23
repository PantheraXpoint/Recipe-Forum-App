import 'package:flutter/material.dart';
import 'package:flutter_application_2/components/constaints.dart';
import 'package:flutter_application_2/model/noti_db.dart';

class NotificationScreen extends StatelessWidget {
  getNoti() async {
    final noti = await DatabaseProvider.db.getNoti();
    return noti;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Notes",
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder(
          future: getNoti(),
          builder: (context, notiData) {
            switch (notiData.connectionState) {
              case ConnectionState.waiting:
                {
                  return Center(child: CircularProgressIndicator());
                }
              case ConnectionState.done:
                {
                  if (notiData.data == Null) {
                    return Center(
                      child: Text("You don't have any notes yet, create one"),
                    );
                  } else {
                    return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: notiData.data.length,
                          itemBuilder: (context, index) {
                            String title = notiData.data[index]['title'];
                            String date = notiData.data[index]['date'];
                            return Card(
                                child: ListTile(
                              onTap: () {},
                              title: Text(title),
                              subtitle: Text(date),
                            ));
                          },
                        ));
                  }
                }
            }
          }),
    );
  }
}
