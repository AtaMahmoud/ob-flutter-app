import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ocean_builder/constants/constants.dart';
 
class FilterDropDown extends StatefulWidget {

  final dynamic changed;
  final List<String> list;

  FilterDropDown({this.list,this.changed});
 
  final String title = "Filter List";
 
  @override
  FilterDropDownState createState() => FilterDropDownState();
}
 
class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
 
class FilterDropDownState extends State<FilterDropDown> {
 
  final _debouncer = Debouncer(milliseconds: 500);
  List<String> users = List();
  List<String> filteredUsers = List();
 
  @override
  void initState() {
    super.initState();
        users = widget.list;//ListHelper.getCountryList();
        filteredUsers = users;
 
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
          color: ColorConstants.MODAL_BKG.withOpacity(.85),
          borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.fromLTRB(
            8,
            16,
            8,
            32
          ),
      child: Stack(
              children: <Widget>[
          Column(
            children: <Widget>[
              TextField(
                keyboardAppearance: Brightness.light,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16.0),
                  hintText: 'Filter by name',
                  hintStyle: TextStyle(color: Colors.white),


                  
                ),
                onChanged: (string) {
                  _debouncer.run(() {
                    setState(() {
                      filteredUsers = users
                          .where((u) => (u
                                  .toLowerCase()
                                  .contains(string.toLowerCase())))
                          .toList();
                    });
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: filteredUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        widget.changed(filteredUsers[index]);
                        Navigator.of(context).pop();

                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                filteredUsers[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

                    Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              // color: ColorConstants.MODAL_BKG.withOpacity(.375),
              padding: EdgeInsets.only(top: 8.0, right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            ImagePaths.cross,
                            width: 15,
                            height: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}