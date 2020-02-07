import 'package:app/logic/activity_provider.dart';
import 'package:app/models/activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget{
  
   Activity activity;

   Explore({
    Key key, this.activity
    }) : super(key: key);
  @override
  _ExploreState createState() => _ExploreState();

}

class _ExploreState extends State<Explore>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
         
            
            child: ListItemsActivities() ,
          

        )
    );

  }

}

class ListItemsActivities extends StatefulWidget{
  @override
  _ListItemsActivitiesState createState() => _ListItemsActivitiesState();

}

class _ListItemsActivitiesState extends State<ListItemsActivities>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
      children: <Widget>[

        Expanded(
          child: Container(
      child: Consumer<ActivityProvider>(
        builder: (context, activity, child){
          return ListView.builder(
            itemCount: activity.lisActivity.length,
            itemBuilder: (context, index){
              return Container(
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
                  title: Text(activity.lisActivity[index].title, style : TextStyle(color: Colors.black87,
                                fontWeight: FontWeight.bold),),
                  subtitle: Text(activity.lisActivity[index].location, style: TextStyle(color: Colors.black45,
                                fontWeight: FontWeight.bold),),
                  trailing:  Icon(Icons.check_circle, color: Colors.greenAccent,),
                  
                  
                ),
                margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
              );
                
            },
            );
        })
        ),
        
          ) 

    ],
    
    ),
    floatingActionButton:FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.greenAccent,
      onPressed:() =>{
        Provider.of<ActivityProvider>(context).lisActivity
      }),
    );
    
  }
  

}



/*class ItemActivity extends StatelessWidget{
  final Activity initialActivity;
  
   ItemActivity({
    Key key, 
    this.initialActivity}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
  return InkWell(
    child: Container(
      padding:const EdgeInsets.all(10.0),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(initialActivity.title),
              Text(initialActivity.location),
              Text(initialActivity.duration),
            ],
          ),

        //  Container(
        //    decoration: BoxDecoration(
        //      borderRadius: BorderRadius.circular(25.0) ,
        //      image: DecorationImage(
        //        image: AssetImage(urlPhoto),
        //      )
        //    ),
        //  ),

        ],
      ),

    ),
    onTap: () => {print("Ok")},
  );

  }

}*/
