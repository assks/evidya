import 'package:evidya/utils/helper.dart';
import 'package:evidya/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evidya/model/course_modal.dart';
import 'Courselist_Item.dart';
import 'courses_bloc.dart';
import 'courses_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({Key key}) : super(key: key);

  @override
  _CoursesListState createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  final _scrollController = ScrollController();
  List<Courses> courses;

  @override
  void initState() {
    super.initState();
    //_scrollController.addListener(_onScroll);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Courses_Bloc, Courses_State>(
        builder: (context, state) {
          switch (state.status) {
            case CoursesStatus.failure:
              return const Center(child: Text('failed to fetch posts'));
            case CoursesStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('no posts'));
              }
              return Center(
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(
                      height: getProportionateScreenHeight(460),
                      child: Scaffold(
                        body: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return  index >= state.posts.length
                                ? const Center(child: CircularProgressIndicator())
                                : CourseList_Item(post: state.posts[index]);
                          },
                          itemCount: state.hasReachedMax
                              ? state.posts.length
                              : state.posts.length /*+ 1*/,
                          controller: _scrollController,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      );
  }

  Widget _courses_list(Courses_State state) {
    return state.posts.length != null
        ? Container(
        child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(state.posts.length, (index) {
              return GridTile(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.white,/*_randomColor
                              .randomColor(
                                colorBrightness: ColorBrightness.veryLight,
                              ).withOpacity(0.3),*/

                    child: GestureDetector(

                      onTap: () {

                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Course_Detail_Screen(course: courses[index])));*/
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: CachedNetworkImage(
                                      height:
                                      MediaQuery.of(context).size.height * 0.07,
                                      width:
                                      MediaQuery.of(context).size.width * 0.2,
                                      fit: BoxFit.cover,
                                      imageUrl:
                                      "https://bvidya.websites4demo.com/" +
                                          /*courses[index].image.toString(),*/
                                          state.posts[index].image.toString(),
                                      placeholder: (context, url) =>
                                          Helper.onScreenProgress(),
                                      errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4,
                                    child: Text(

                                        state.posts[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })))
        : Container(
      child: const Text("No Data found"),    );
  }
}
