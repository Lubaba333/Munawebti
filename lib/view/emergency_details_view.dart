import 'package:flutter/material.dart';
import 'package:supervisors/const/app_colors.dart';


class EmergencyDetailsView extends StatelessWidget {


  final dynamic emergency;


  const EmergencyDetailsView({
    super.key,
    required this.emergency,
  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      // backgroundColor: const Color(0xffF5F6FA),


      appBar: AppBar(

        backgroundColor: AppColors.primary,

        elevation:0,

        title: const Text(
          "Emergency Details",
        ),

      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            _header(),


            const SizedBox(height:20),



            _section(

              title:"Student Information",

              icon:Icons.person,

              children:[


                _item(
                  "Name",
                  emergency.student.fullName,
                ),


                _item(
                  "Student ID",
                  emergency.student.id.toString(),
                ),



                _item(
                  "Email",
                  emergency.student.email.isNotEmpty
                      ? emergency.student.email
                      : "-",
                ),



                _item(
                  "Phone",
                  emergency.student.phoneNumber.isNotEmpty
                      ? emergency.student.phoneNumber
                      : "-",
                ),



                _item(
                  "Specialization",
                  emergency.student.specialization.isNotEmpty
                      ? emergency.student.specialization
                      : "-",
                ),



                _item(
                  "Year",
                  emergency.student.year.toString(),
                ),



                _item(
                  "Resident",
                  emergency.student.isResident
                      ? "Yes"
                      : "No",
                ),


              ],

            ),




            const SizedBox(height:20),




            _section(

              title:"Emergency Status",

              icon:Icons.timeline,


              children:[



                _item(
                  "Status",
                  emergency.status,
                ),



              ],


            )


          ],

        ),

      ),
    );

  }






  Widget _header(){


    return Container(

      padding:const EdgeInsets.all(20),


      decoration:BoxDecoration(

        gradient:LinearGradient(

            colors:[

              AppColors.primary,

              AppColors.primary.withOpacity(.7)

            ]

        ),


        borderRadius:BorderRadius.circular(22),

      ),



      child:Column(

        crossAxisAlignment:CrossAxisAlignment.start,

        children:[



          Row(

            children:[


              const Icon(

                Icons.warning,

                color:Colors.white,

                size:35,

              ),



              const SizedBox(width:12),




              Expanded(

                child:Text(

                  emergency.title,

                  style:const TextStyle(

                    fontSize:22,

                    fontWeight:FontWeight.bold,

                    color:Colors.white,

                  ),

                ),

              )


            ],

          ),



          const SizedBox(height:15),



          Text(

            emergency.description,

            style:const TextStyle(

              color:Colors.white70,

              fontSize:16,

            ),

          ),



          const SizedBox(height:15),



          Container(

            padding:const EdgeInsets.symmetric(

              horizontal:15,

              vertical:7,

            ),


            decoration:BoxDecoration(

              color:Colors.white24,

              borderRadius:BorderRadius.circular(20),

            ),


            child:Text(

              emergency.status,

              style:const TextStyle(

                color:Colors.white,

                fontWeight:FontWeight.bold,

              ),

            ),

          )


        ],


      ),

    );


  }







  Widget _section({

    required String title,

    required IconData icon,

    required List<Widget> children,


  }){


    return Container(


      padding:const EdgeInsets.all(18),


      decoration:BoxDecoration(

        color:Colors.white,

        borderRadius:BorderRadius.circular(20),

      ),



      child:Column(

        crossAxisAlignment:CrossAxisAlignment.start,


        children:[



          Row(

            children:[


              Icon(
                icon,
                color:AppColors.primary,
              ),


              const SizedBox(width:8),



              Text(

                title,

                style:const TextStyle(

                  fontSize:18,

                  fontWeight:FontWeight.bold,

                ),

              )



            ],

          ),




          const SizedBox(height:15),



          ...children



        ],


      ),


    );



  }





  Widget _item(String title,String value){


    return Padding(

      padding:const EdgeInsets.only(bottom:12),


      child:Row(

        crossAxisAlignment:CrossAxisAlignment.start,

        children:[



          SizedBox(

            width:110,

            child:Text(

              title,

              style:TextStyle(

                color:Colors.grey.shade600,

              ),

            ),

          ),



          Expanded(

            child:Text(

              value,

              style:const TextStyle(

                fontWeight:FontWeight.w600,

              ),

            ),

          )



        ],


      ),


    );


  }



}