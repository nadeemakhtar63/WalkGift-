
  import 'package:flutter/material.dart';
  import 'package:googleapis/fitness/v1.dart' as fitness;
  import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/src/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class GoogleFitIntegration extends StatefulWidget {
    @override
    _GoogleFitIntegrationState createState() => _GoogleFitIntegrationState();
  }

  class _GoogleFitIntegrationState extends State<GoogleFitIntegration> {
    int _stepCount = 0;
    String accesstoken='';
    String idToken="";
    void _loadData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        accesstoken = prefs.getString('accessToken') ?? '';
        // idToken = prefs.getString('idToken') ?? '';
      });
      _getStepCount();
    }
    @override
    void initState() {
      super.initState();
      _loadData();
      // _getStepCount();
    }
  var  expiry_date = DateTime(DateTime.friday);
    Future<void> _getStepCount() async {
      // Authenticate user
      final credentials = auth.AccessCredentials(
        auth.AccessToken(accesstoken,'',expiry_date),
        null, // Refresh token is not needed for this authentication method
        ['https://www.googleapis.com/auth/fitness.activity.read'],
      );

      final authClient = auth.authenticatedClient(credentials as Client,credentials);

      // Query step count
      final fitnessApi = fitness.FitnessApi(authClient);
      try {
        final dataSources = await fitnessApi.users.dataSources.list("me");

        // Look for step count data source
        for (final dataSource in dataSources.dataSource!) {
          if (dataSource.dataStreamId ==
              "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps") {
            final datasets = await fitnessApi.users.dataSources.datasets.get(
              "me",
              dataSource.dataStreamId!,
              DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch.toString(),
              limit: DateTime.now().millisecondsSinceEpoch,
            );

            // Aggregate step count
            if (datasets.point != null) {
              _stepCount = datasets.point!
                  .fold(0, (prev, element) => prev + (element.value![0].intVal)!);
            }
            break;
          }
        }
      } catch (e) {
        print("Error retrieving step count: $e");
      }

      // Update UI with step count
      setState(() {});
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Google Fit Integration'),
        ),
        body: Center(
          child: Text('Step count: $_stepCount'),
        ),
      );
    }
  }
