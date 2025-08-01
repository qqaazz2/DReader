import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/book/SeriesCover.dart';
import 'package:DReader/entity/book/SeriesCoverList.dart';
import 'package:DReader/state/book/SeriesContentState.dart';
import 'package:DReader/state/book/SeriesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

class SeriesChangeCover extends ConsumerStatefulWidget {
  SeriesChangeCover({super.key, required this.seriesId});

  int seriesId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SeriesChangeCoverState();
}

class SeriesChangeCoverState extends ConsumerState<SeriesChangeCover> {
  late List<SeriesCover> list;
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  @override
  Widget build(BuildContext context) {
    ref
        .read(seriesContentStateProvider(widget.seriesId).notifier)
        .getCoverList();
    // final state = ref.watch(seriesContentStateProvider(widget.seriesId));

    return Material(
      child: FutureBuilder(
        future: ref
            .read(seriesContentStateProvider(widget.seriesId).notifier)
            .getCoverList(),
        builder:
            (BuildContext context, AsyncSnapshot<SeriesCoverList> snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
                itemCount: snapshot.data?.list?.length ?? 0,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 2, childAspectRatio: 0.7),
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      // snapshot.data?.list?[index].coverPath
                      child: Image.asset("images/1.png", fit: BoxFit.fill));
                });
          } else {
            // 请求未结束，显示loading
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  String splicingPath(String? filePath) {
    String originalString = "${HttpApi.options.baseUrl}$filePath";
    String modifiedString = originalString.replaceFirst('\\', '');
    modifiedString = modifiedString.replaceAll('\\', '/');
    return modifiedString;
  }

  Widget imageModule(String? path) {
    // if(kIsWeb){
    //   return Image.network(path,width: double.infinity,height: double.infinity,headers: map,errorBuilder:(context,object,stackTrace) => Image.asset("images/1.png"));
    // }else{
    return Image.asset("images/1.png", fit: BoxFit.fill);

    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      imageUrl: path!,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      httpHeaders: map,
      errorWidget: (context, url, error) => const Icon(Icons.folder, size: 150),
      fit: BoxFit.cover,
    );
    // }
  }
}
