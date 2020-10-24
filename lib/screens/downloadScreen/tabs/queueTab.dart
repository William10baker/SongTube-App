import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songtube/internal/models/downloadinfoset.dart';
import 'package:songtube/provider/downloadsProvider.dart';
import 'package:songtube/screens/downloadScreen/components/downloadTile.dart';
import 'package:songtube/screens/downloadScreen/components/downloadsEmpty.dart';

class DownloadsQueueTab extends StatefulWidget {
  @override
  _DownloadsQueueTabState createState() => _DownloadsQueueTabState();
}

class _DownloadsQueueTabState extends State<DownloadsQueueTab> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: downloadsBody(context)
    );
  }

  Widget downloadsBody(BuildContext context) {
    DownloadsProvider downloadsProvider = Provider.of<DownloadsProvider>(context);
    if (downloadsProvider.downloadingList.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 16),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 16, bottom: 16),
                      child: Text(
                        "Downloading",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'YTSans'
                        ),
                      )
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: downloadsProvider.downloadingList.length,
                    itemBuilder: (context, index) {
                      DownloadInfoSet infoset = downloadsProvider.downloadingList[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: StreamBuilder<Object>(
                          stream: infoset.downloadStatus.stream,
                          builder: (context, snapshot) {
                            return DownloadTile(
                              dataProgress: infoset.dataProgress.stream,
                              progressBar: infoset.progressBar.stream,
                              currentAction: infoset.currentAction.stream,
                              metadata: infoset.metadata,
                              downloadType: infoset.downloadType,
                              onDownloadCancel: snapshot.data == DownloadStatus.Downloading
                                ? () {
                                  infoset.cancelDownload = true;
                                } : null,
                              cancelDownloadIcon: snapshot.data == DownloadStatus.Downloading
                                ? Icon(Icons.clear, size: 18)
                                : Container()
                            );
                          }
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 16, bottom: 16),
                      child: Text(
                        "Queued",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'YTSans'
                        ),
                      )
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: downloadsProvider.queueList.length,
                    itemBuilder: (context, index) {
                      DownloadInfoSet infoset = downloadsProvider.queueList[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                        child: DownloadTile(
                          dataProgress: infoset.dataProgress.stream,
                          progressBar: infoset.progressBar.stream,
                          currentAction: infoset.currentAction.stream,
                          metadata: infoset.metadata,
                          downloadType: infoset.downloadType,
                          onDownloadCancel: null,
                          cancelDownloadIcon: Container()
                        )
                      );
                    },
                  ),
                ],
              ),
            ),
          ]
        ),
      );
    } else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: const NoDownloads()
      );
    }
  }
}