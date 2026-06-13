import 'package:flutter/material.dart';
import 'package:supervisors/models/request_model.dart';
import '../const/app_colors.dart';


class RequestDetailsView extends StatefulWidget {


  final RequestModel request;


  const RequestDetailsView({
    super.key,
    required this.request,
  });



  @override
  State<RequestDetailsView> createState() =>
      _RequestDetailsViewState();

}



class _RequestDetailsViewState
    extends State<RequestDetailsView>
    with SingleTickerProviderStateMixin {


  late AnimationController animationController;

  late Animation<double> fade;


  @override
  void initState(){

    super.initState();


    animationController =
        AnimationController(

          vsync:this,

          duration:
          const Duration(milliseconds:600),

        );


    fade = CurvedAnimation(

      parent: animationController,

      curve:
      Curves.easeOut,

    );


    animationController.forward();


  }




  @override
  void dispose(){

    animationController.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context) {


    final request = widget.request;


    return Scaffold(


      backgroundColor:
      AppColors.background,


      appBar: AppBar(

        title:
        const Text(
          "Request Details",
        ),


        backgroundColor:
        AppColors.primary,

      ),





      body:

      FadeTransition(

        opacity: fade,


        child:

        ScaleTransition(

          scale: Tween<double>(

            begin:0.92,

            end:1,

          ).animate(fade),



          child:

          SingleChildScrollView(


            padding:
            const EdgeInsets.all(20),



            child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[



                  /// HEADER

                  Text(

                    request.title,


                    style:const TextStyle(

                      fontSize:26,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:12),



                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal:15,

                      vertical:7,

                    ),


                    decoration:

                    BoxDecoration(

                      color:
                      _statusColor(request.status)
                          .withOpacity(.15),


                      borderRadius:
                      BorderRadius.circular(20),

                    ),



                    child:Text(

                      request.status.toUpperCase(),

                      style:TextStyle(

                        color:
                        _statusColor(request.status),

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),

                  ),




                  const SizedBox(height:30),




                  _sectionTitle(
                    "Description",
                  ),



                  const SizedBox(height:8),



                  Text(

                    request.description,


                    style:

                    const TextStyle(

                      fontSize:16,

                      height:1.5,

                    ),

                  ),




                  const SizedBox(height:30),





                  _sectionTitle(
                    "Request Information",
                  ),



                  const SizedBox(height:15),



                  _infoRow(
                    Icons.category,
                    "Type",
                    request.type,
                  ),



                  _infoRow(
                    Icons.date_range,
                    "Created",
                    request.createdAt ?? "-",
                  ),





                  const SizedBox(height:30),





                  _sectionTitle(
                    "Additional Data",
                  ),



                  const SizedBox(height:15),





                  ...request.metadata.entries.map(

                        (e)=>

                        _infoRow(

                          Icons.info_outline,

                          e.key,

                          e.value.toString(),

                        ),


                  ),



                  if(request.adminResponseReason != null)

                    Column(

                        children:[


                          const SizedBox(height:30),



                          _sectionTitle(
                            "Admin Response",
                          ),



                          const SizedBox(height:10),


                          Text(

                            request.adminResponseReason!,

                            style:
                            const TextStyle(

                              fontSize:16,

                            ),

                          )



                        ]

                    )





                ]

            ),


          ),


        ),


      ),


    );



  }







  Widget _sectionTitle(String text){


    return Text(

      text,


      style:
      const TextStyle(

        fontSize:20,

        fontWeight:
        FontWeight.bold,

      ),

    );


  }





  Widget _infoRow(

      IconData icon,

      String title,

      String value,

      ){


    return Padding(

      padding:
      const EdgeInsets.only(bottom:15),


      child:Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children:[


          Icon(

            icon,

            color:
            AppColors.primary,

            size:22,

          ),


          const SizedBox(width:12),



          Expanded(

            child:Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,


              children:[


                Text(

                  title,

                  style:

                  const TextStyle(

                    color:
                    Colors.grey,

                    fontSize:13,

                  ),

                ),


                const SizedBox(height:3),



                Text(

                  value,

                  style:

                  const TextStyle(

                    fontSize:16,

                    fontWeight:
                    FontWeight.w500,

                  ),

                )



              ],

            ),


          )



        ],

      ),


    );


  }





  Color _statusColor(String status){


    switch(status){


      case "approved":

        return Colors.green;



      case "rejected":

        return Colors.red;



      default:

        return Colors.orange;


    }


  }


}