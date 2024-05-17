import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TheListTile extends StatelessWidget {
  final String title;
  final String trailing;
  final void Function(BuildContext)? onEditPresed;
  final void Function(BuildContext)? onDelatePresed;

  const TheListTile({
    super.key,
    required this.title,
    required this.trailing,
    required this.onEditPresed,
    required this.onDelatePresed
    
    });

  @override
  Widget build(BuildContext context) {
     return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
          children:[
            //settings 
            SlidableAction(
              onPressed: onEditPresed,
              icon: Icons.settings,
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(4),
              ),
              // delate
              SlidableAction(
              onPressed: onDelatePresed,
              icon: Icons.delete,
              backgroundColor: Color.fromARGB(132, 196, 2, 2),
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(4),
              ),

          ]
        ), 
       
       child: ListTile(
                title: Text(title),
                trailing: Text(trailing),
              ),
     );
  }
}