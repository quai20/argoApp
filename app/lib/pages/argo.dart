import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Argo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About Argo"),
        ),
        body: Center(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
                height: 100,                      
                decoration: BoxDecoration(
                  color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/argo-inter.png"),
                        fit: BoxFit.scaleDown)),
              ),
              Container(
              height: 30,
              color: Colors.white,
              child: Text(' '),
            ),
            Container(                               
                color: Colors.white, 
                child: Text(
                    '''
Argo is an international program that uses profiling floats to observe temperature, salinity, currents, and, recently, bio-optical properties in the Earth's oceans; it has been operational since the early 2000s. The real-time data it provides is used in climate and oceanographic research. A special research interest is to quantify the ocean heat content (OHC).
The Argo fleet consists of almost 4000 drifting "Argo floats" (as profiling floats used by the Argo program are often called) deployed worldwide. Each float weighs 20–30 kg. In most cases probes drift at a depth of 1000 metres (the so-called parking depth) and, every 10 days, by changing their buoyancy, dive to a depth of 2000 metres and then move to the sea-surface, measuring conductivity and temperature profiles as well as pressure. From these, salinity and density can be calculated. Seawater density is important in determining large-scale motions in the ocean. Average current velocities at 1000 metres are directly measured by the distance and direction a float drifts while parked at that depth, which is determined by GPS or Argos system positions at the surface. The data are transmitted to shore via satellite, and are freely available to everyone, without restrictions.
The Argo program is named after the Greek mythical ship Argo to emphasize the complementary relationship of Argo with the Jason satellite altimeters. Both the standard Argo floats and the 4 satellites launched so far to monitor changing sea-level all operate on a 10-day duty cycle. 
                    ''',
                    textAlign: TextAlign.justify,
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              Container(
              height: 30,
              color: Colors.white,
              child: new InkWell(
                  child: new Text('Learn more on Argo program',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, decoration: TextDecoration.underline)),
                  onTap: () => launch(
                      'https://www.umr-lops.fr/SNO-Argo/SNO-Argo-France')),
            )
          ],
        )));
  }
}
