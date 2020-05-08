import 'package:flutter/material.dart';

class Argo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About Argo"),
        ),
        body: new Container(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
              height: 20,
              color: Colors.white,
              child: Text(' '),
            ),    
              Container(
                height: 100,               
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icon.png"),
                        fit: BoxFit.scaleDown)),
              ),
              Container(
              height: 20,
              color: Colors.white,
              child: Text(''),
            ),
              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  child: new Text(
                    '''
Current Status of Argo
\n
The broad-scale global array of temperature/salinity profiling floats, known as Argo, has already grown to be a major component of the ocean observing system. Argo is a standard to which other developing ocean observing systems can look to. For example, Argo offers ideas on various topics such as how to collaborate internationally, how to develop a data management system and how to change the way scientists think about collecting data. Deployments began in 2000 and continue today at the rate of about 800 per year.
\n
Brief History of Argo
\n
The name Argo was chosen to emphasize the strong complementary relationship of the global float array with the Jason satellite altimeter mission. In Greek mythology Jason sailed in a ship called "Argo" to capture the golden fleece. Together the Argo and Jason data sets are assimilated into computer models developed by GODAE OceanView that will allow a test of our ability to forecast ocean climate. For the first time, the physical state of the upper ocean is being systematically measured and the data assimilated in near real-time into computer models.  Argo builds on other upper-ocean ocean observing networks, extending their coverage in space an time, their depth range and accuracy, and enhancing them through the addition of salinity and velocity measurements.  Argo is not confined to major shipping routes which can vary with season as the other upper-ocean observing networks are. Instead, the global array of 3,000 floats will be distributed roughly every 3 degrees (300km). Argo is the sole source of global subsurface datasets used in all ocean data assimilation models and reanalyses.
\n
Argo's Objectives
\n
It will provide a quantitative description of the changing state of the upper ocean and the patterns of ocean climate variability from months to decades, including heat and freshwater storage and transport. The data will enhance the value of the Jason altimeter through measurement of subsurface temperature, salinity, and velocity, with sufficient coverage and resolution to permit interpretation of altimetric sea surface height variability.
\n
Argo data will be used for initializing ocean and coupled ocean-atmosphere forecast models, for data assimilation and for model testing.A primary focus of Argo is to document seasonal to decadal climate variability and to aid our understanding of its predictability. A wide range of applications for high-quality global ocean analyses is anticipated.
\n
Argo Design and Data
\n
The design of the Argo network is based on experience from the present observing system, on recent knowledge of variability from the TOPEX/Poseidon altimeter, and on the requirements for climate and high-resolution ocean models.  The array of ~4000 floats provides 100,000 temperature/salinity (T/S) profiles and velocity measurements per year distributed over the global oceans at an average 3-degree spacing. Floats will cycle to 2000m depth devery 10 days, with 4-5 year lifetimes for individual instruments. All data collected by Argo floats are publically available in near real-time via the Global Data Assembly Centers (GDACs) in Brest, France and Monterey, California after an automated quality control (QC), and in scientifically quality controlled form, delayed mode data, via the GDACs within one year of collection.                    ''',
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ])));
  }
}
