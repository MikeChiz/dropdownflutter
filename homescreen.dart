import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownScreen extends StatefulWidget {

  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {

  //String url = "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/countries%2Bstates%2Bcities.json";
  

  var _statexs = [];
  var _lgaxs = [];
  var _wardxs = [];

// these will be the values after selection of the item
  String? statex;
  String? wardx;
  String? lgax;

// this will help to show the widget after
  bool isStatexSelected = false;
  bool isLgaxSelected = false;

  //http get request to get data from the link
  Future getWorldData()async{
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body);

      setState(() {
        _statexs = jsonResponse;
      });


      print(_statexs);
    }
  }

  @override
  void initState() {

    getWorldData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Multiple Dynamic Dependent Dropdown")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //========================States

            if (_statexs.isEmpty) const Center(child: CircularProgressIndicator()) else Card(
              color: Colors.purple.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButton<String>(
                    underline: Container(),
                    hint: Text("Select Countries"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    items: _statexs.map((ste){
                      return DropdownMenuItem<String>(
                          value: ste["id"].toString(),
                          child: Text(ste["name"])
                      );
                    }).toList(),
                    value: statex,
                    onChanged: (value){
                      setState(() {
                        _lgaxs = [];
                        statex = value!;
                        for(int i =0; i<_statexs.length; i++){
                          if(_statexs[i]["id"].toString() == value){
                            _lgaxs = _statexs[i]["states"];
                          }
                        }
                        isStatexSelected = true;
                      });
                    }),
              ),
            ),

//======================================= lgas
            if(isStatexSelected)
              Card(
                color: Colors.purple.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(

                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text("Select States"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      items: _lgaxs.map((st){
                        return DropdownMenuItem<String>(
                            value: st["id"].toString(),
                            child: Text(st["name"])
                        );
                      }).toList(),
                      value: lgax,
                      onChanged: (value){
                        setState(() {

                          _wardxs = [];
                          lgax = value!;
                          for(int i =0; i<_lgaxs.length; i++){
                            if(_lgaxs[i]["id"].toString() == value){
                              _wardxs = _lgaxs[i]["cities"];
                            }
                          }
                          isLgaxSelected = true;
                        });
                      }),
                ),
              ) else Container(),


            //=============================== ward
            if(isLgaxSelected)
              Card(
                color: Colors.purple.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: DropdownButton<String>(
                      underline: Container(),
                      hint: Text("Select Cities"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isDense: true,
                      isExpanded: true,
                      items: _wardxs.map((ct){
                        return DropdownMenuItem<String>(
                            value: ct["id"].toString(),
                            child: Text(ct["name"])
                        );
                      }).toList(),
                      value: wardx,
                      onChanged: (value){
                        setState(() {


                          wardx = value!;

                        });
                      }),
                ),
              ) else Container(),

          ],),
      ),
    );
  }
}
