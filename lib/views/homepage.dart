import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Text("BMD Musicss Home", style: Theme.of(context).textTheme.bodyLarge,),
          Container(
            decoration: BoxDecoration(
              borderRadius: .circular(12)),
              child: Row(
                children: [
                  Image.asset('Reggae.png', cacheWidth: 100,)
                  ],
                  ),
                  )
        ],
      ),),
    );
  }
}