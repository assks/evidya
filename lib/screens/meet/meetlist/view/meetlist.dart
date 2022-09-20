
import 'package:evidya/resources/app_colors.dart';
import 'package:evidya/screens/meet/meetlist/bloc/meetlist_bloc.dart';
import 'package:evidya/screens/meet/meetlist/view/listitem.dart';
import 'package:evidya/widget/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:sizer/sizer.dart';

class MeetList extends StatefulWidget {
  final String userName;
  const MeetList({ this.userName,Key key}) : super(key: key);

  @override
  _MeetListState createState() => _MeetListState();
}

class _MeetListState extends State<MeetList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetList_Bloc, MeetList_State>(
      builder: (context, state) {
        switch (state.status) {
          case MeetList_Status.failure:
            return const Center(child: Text('failed to fetch posts'));
          case MeetList_Status.success:
            if (state.posts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('No Meeting Scheduled !',style: TextStyle(fontSize: 15,color: AppColors.appNewDarkThemeColor),)
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.h,),
                child: ListView.separated(
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length
                        ? BottomLoader()
                        : MeetListItem(post: state.posts[index],userName : widget.userName);
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length,
                  controller: _scrollController,
                  separatorBuilder: (BuildContext context, int index) =>SizedBox(height: 2.h,),
                ),
              )
            );

          default:
            return Center(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               SizedBox(
                 height: 20,
                 width: 20,
                 child:  CircularProgressIndicator(
                   strokeWidth: 1,
                 ),
               ),
                SizedBox(width: 10,),
                Text("Fetching Data...",style: TextStyle(fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),)
              ],
            ));
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<MeetList_Bloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
