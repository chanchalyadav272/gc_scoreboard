import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../functions/filters/manthan_schedule_filter.dart';
import '../../globals/styles.dart';
import '../../services/api.dart';
import '../../stores/common_store.dart';
import '../../stores/manthan_store.dart';
import '../../widgets/cards/results/manthan_result_card.dart';
import '../../widgets/ui/err_reload.dart';
import '../../widgets/ui/shimmer.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/filters/manthan_filter_bar.dart';



class ManthanResultsPage extends StatefulWidget {
  const ManthanResultsPage({Key? key}) : super(key: key);

  @override
  State<ManthanResultsPage> createState() => _ManthanResultsPageState();
}

class _ManthanResultsPageState extends State<ManthanResultsPage> {
  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();
    var manthanStore = context.read<ManthanStore>();

    reloadCallback() {
      // reload page
      setState(() {});
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const TopBar(),
          const ManthanFilterBar(),
          FutureBuilder<List<dynamic>>(
              future: APIService(context).getResults(commonStore.viewType,competition: 'manthan'),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ShowShimmer(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                            ),
                          );
                        }),
                  );
                } else if (snapshot.hasData) {
                  return Observer(builder: (context) {
                    List<dynamic> filteredEventSchedules = manthanFilterSchedule(input: snapshot.data!, module: manthanStore.selectedModule, );
                    return Expanded(
                        child: filteredEventSchedules.isNotEmpty
                            ? ListView.builder(
                            itemCount: filteredEventSchedules.length,
                            itemBuilder: (context, index) {
                              return ManthanResultCard(
                                  eventModel:
                                  filteredEventSchedules[index]);
                            })
                            : Center(
                          child:
                          Text("No Result found", style: fontStyle1),
                        ));
                  });
                }
                return ErrorReloadPage(apiFunction: reloadCallback);
              })
        ],
      ),
    );
  }
}
