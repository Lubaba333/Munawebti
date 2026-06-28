import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class StudentRecordSection extends StatelessWidget {


  final String title;

  final IconData icon;

  final Color color;

  final List<Widget> children;



  const StudentRecordSection({

    super.key,

    required this.title,

    required this.icon,

    required this.color,

    required this.children,

  });



  @override
  Widget build(BuildContext context){


    return Card(

      margin:
      const EdgeInsets.only(bottom:15),


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),

      ),



      child:

      ExpansionTile(


        tilePadding:
        const EdgeInsets.symmetric(
          horizontal:18,
          vertical:5,
        ),


        leading:

        Container(

          padding:
          const EdgeInsets.all(10),

          decoration:

          BoxDecoration(

            color:
            color.withOpacity(.15),

            shape:
            BoxShape.circle,

          ),


          child:

          Icon(

            icon,

            color:
            color,

          ),

        ),



        title:

        Text(

          title,

          style:

          const TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize:18,

          ),

        ),


        children:

        children
            .asMap()
            .entries
            .map(
              (entry){

            int index = entry.key;

            Widget child = entry.value;


            return child
                .animate()
                .fadeIn(

              duration:
              350.ms,

              delay:
              (index * 80).ms,

            )
                .scale(

              begin:
              const Offset(.95,.95),

              duration:
              350.ms,

            );

          },

        )
            .toList(),

      ),

    ).animate()

        .fadeIn(
      duration:500.ms,
    )

        .scale(
      begin:
      const Offset(.97,.97),

      duration:
      500.ms,
    );





  }

}