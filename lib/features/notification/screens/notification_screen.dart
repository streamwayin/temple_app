import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/notification/bloc/notification_bloc.dart';
import 'package:temple_app/modals/notification_model.dart';
import 'package:temple_app/widgets/utils.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String routeName = "/notification-screen";

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarWithBackButton(context),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'सूचनाएं',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: state.notificationsList.length <= 10
                        ? state.notificationsList.length
                        : 10,
                    itemBuilder: (context, index) {
                      NotificationModel notificationModel =
                          state.notificationsList[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              notificationModel.title,
                              style: TextStyle(fontSize: 20),
                            ),
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    Image.asset('assets/images/app_logo.png')),
                            subtitle: Text(
                              '${notificationModel.body}gsgsaggsdgdsfgsdafgdsffgfsgsfggfsgsfgsfdgfsdgsfgfggfdgdsgresg',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Text(calculateTimeDifference(
                                dateTime, notificationModel.timestamp!)),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String calculateTimeDifference(DateTime currentTime, DateTime timeStamp) {
    Duration difference = currentTime.difference(timeStamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
