import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../globals/colors.dart';
import '../../../globals/enums.dart';
import '../../../globals/styles.dart';
import '../../../models/manthan_models/manthan_event_model.dart';
import '../../../stores/common_store.dart';
import '../card_date_widget.dart';
import '../popup_menu.dart';
import '../menu_item.dart';
import 'score_card_item.dart';

class ManthanResultCard extends StatefulWidget {
  final ManthanEventModel eventModel;
  const ManthanResultCard({super.key, required this.eventModel});

  @override
  State<ManthanResultCard> createState() => _ManthanResultCardState();
}

class _ManthanResultCardState extends State<ManthanResultCard> {
  bool isExpanded = false;
  List<PopupMenuEntry> popupOptions = [
    optionsMenuItem('Edit', 'edit result', Themes.kWhite),
    const PopupMenuDivider(
      height: 2,
    ),
    optionsMenuItem('Delete', 'delete', Themes.errorRed),
  ];

  @override
  Widget build(BuildContext context) {
    var commonStore = context.read<CommonStore>();
    return Observer(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenu(
          eventModel: widget.eventModel,
          items: commonStore.viewType == ViewType.admin ? popupOptions : [],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Themes.cardColor2,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    SizedBox(
                      height: 98,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: SizedBox(
                                  height: 28,
                                  child: Text(widget.eventModel.event,
                                      style: cardEventStyle),
                                ),
                              ),
                              SizedBox(
                                  height: 20,
                                  child: Text(widget.eventModel.module,
                                      style: cardStageStyle1)),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          Container(
                              alignment: Alignment.topCenter,
                              width: 82,
                              child: DateWidget(
                                date: widget.eventModel.date,
                              ))
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(
                    // height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events_outlined,
                                color: Themes.warning,
                                size: 12,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  widget.eventModel.victoryStatement!,
                                  overflow: TextOverflow.visible,
                                  style: cardStageStyle1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Themes.kGrey),
                            width: 64,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Row(
                                children: [
                                  Text(
                                    isExpanded ? 'Less' : 'More',
                                    style: cardResultStyle1,
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_outlined
                                        : Icons.keyboard_arrow_down_outlined,
                                    size: 14,
                                    color: Themes.cardFontColor2,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  isExpanded
                      ? Column(
                          children: [
                            const Divider(
                              height: 32,
                              color: Themes.bottomNavHighlightColor,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: SizedBox(
                                height: 12,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 26,
                                        ),
                                        Text(
                                          'Hostel',
                                          style: cardResultStyle2,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Points',
                                      style: cardResultStyle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      widget.eventModel.results.length * 30,
                                ),
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.eventModel.results.length,
                                    itemBuilder: (context, index) {
                                      return ScoreCardItem(
                                          position: index + 1,
                                          hostelName: widget.eventModel
                                              .results[index].hostelName!,
                                          finalScore: widget.eventModel
                                              .results[index].primaryScore!
                                              .toString(),
                                          secondaryScore: widget.eventModel
                                              .results[index].secondaryScore);
                                    }))
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
