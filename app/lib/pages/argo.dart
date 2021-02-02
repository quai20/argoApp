import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Argo/pages/userpreference.dart';

class Argo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _setAppBarTitle(),
        ),
        body: Center(child: _setContent()));
  }

  _setAppBarTitle() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: SharedPreferencesHelper.getlanguage(),
        initialData: 'english',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 'english':
                {
                  return Text('About Argo');
                }
                break;
              case 'francais':
                {
                  return Text('A propos d\'Argo');
                }
                break;
              case 'spanish':
                {
                  return Text('Sobre Argo');
                }
                break;
            }
          }
        });
  }

  _setContent() {
    return FutureBuilder<String>(
        // get the language, saved in the user preferences
        future: SharedPreferencesHelper.getlanguage(),
        initialData: 'english',
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            var labels;
            switch (snapshot.data) {
              case 'english':
                {
                  labels = [
                    '''
Argo is an international program that uses profiling floats to observe temperature, salinity, currents, and, recently, bio-optical and bio-geochimical properties in the Earth's oceans; it has been operational since the early 2000s. The real-time data it provides is used in climate and oceanographic research. A special research interest is to quantify the ocean heat content (OHC).The Argo fleet consists of almost 4000 drifting "Argo floats" (or "profiling floats" as often called) deployed worldwide. Each float weighs 20–30 kg. In most cases probes drift at a depth of 1000 metres (the so-called parking depth) and, every 10 days, by changing their buoyancy, dive to a depth of 2000 metres and then move to the sea-surface, measuring conductivity and temperature profiles as well as pressure. From these, salinity and density can be calculated. Seawater density is important in determining large-scale motions in the ocean. Average current velocities at 1000 metres are directly measured by the distance and direction a float drifts while parked at that depth, which is determined by float position at the surface. The data are transmitted to shore via satellite, and are freely available to everyone, without restrictions. The Argo program is named after the Greek mythical ship Argo to emphasize the complementary relationship of Argo with the Jason satellite altimeters.
                    ''',
                    'Learn more about argo :'
                  ];
                }
                break;
              case 'francais':
                {
                  labels = [
                    '''
Argo est un programme international utilisant des flotteurs dit "profileurs" pour observer la température, la salinité, les courants et, depuis peu, les propriétés bio-optiques et bio-géochimiques des océans ; il est opérationnel depuis le début des années 2000. Les données en temps réel qu'il fournit sont utilisées dans la recherche climatique et océanographique. Un intérêt particulier de la recherche est de quantifier le contenu thermique de l'océan (OHC).Le réseau Argo se compose de près de 4000 "flotteurs" (ou "profileurs") à la dérive, déployés dans le monde entier. Chaque flotteur pèse entre 20 et 30 kg. Dans la plupart des cas, ils dérivent à une profondeur de 1000 mètres (profondeur de "parking") et, tous les 10 jours, en changeant leur flottabilité, ils plongent à une profondeur de 2000 mètres et se remontent ensuite à la surface, mesurant la conductivité, la température ainsi que la pression. À partir de ces données, il est possible de calculer la salinité et la densité. La densité de l'eau de mer est importante pour déterminer les mouvements à grande échelle de masse d'eau dans l'océan. Les vitesses moyennes des courants à 1000 mètres sont directement calculées via distance et la direction vers laquelle un flotteur dérive lorsqu'il est stationné à sa profondeur de parking, qui sont déterminés par les positions du flotteur à la surface. Les données sont transmises à la côte par satellite et sont accessibles à tous, sans restriction. Le programme Argo est nommé d'après le navire mythique grec Argo pour souligner la relation complémentaire d'Argo avec les altimètres du satellite Jason.
                    ''',
                    'Pour en savoir plus sur Argo :'
                  ];
                }
                break;
              case 'spanish':
                {
                  labels = [
                    '''
Argo es un programa internacional que utiliza boyas perfiladoras para observar la temperatura, salinidad, corrientes y, recientemente, las propiedades bio-ópticas y bio-geoquímicas en los océanos de la Tierra; ha estado en funcionamiento desde principios de los 2000. Los datos en tiempo real que proporciona este programa se utilizan en investigación climática y oceanográfica. Un tema de investigación de especial interés es la cuantificación del contenido térmico del océano. La flota Argo consta de casi 4000 boyas Argo a la deriva (o boyas perfiladoras, como se suelen llamar) desplegadas en todo el mundo. Cada boya pesa entre 20-30 kg. En la mayoría de los casos, las boyas se desplazan a una profundidad de 1000 metros (llamada profundidad de estacionamiento o “parking depth” en inglés) y cada 10 días, mediante un cambio en su flotabilidad, se sumergen a una profundidad de 2000 metros para luego volver a la superficie, midiendo perfiles de conductividad y temperatura además de presión. A partir de estos datos, se puede calcular la salinidad y la densidad. La densidad del agua de mar es importante para determinar movimientos de gran escala en el océano. La velocidad media de las corrientes a 1000 metros se mide directamente a partir de la distancia y dirección con las que se desplaza una boya mientras se encuentra “estacionada” a esa profundidad, lo que se determina gracias a la posición de la boya en superficie. Los datos se transmiten a costa vía satelital, y están disponibles gratuitamente para todos, sin restricciones. El programa Argo lleva el nombre del mítico barco griego Argo para enfatizar la relación complementaria de Argo con los satélites altimétricos Jason.
                    ''',
                    'Obtenga más información sobre Argo :'
                  ];
                }
                break;
            }
            return ListView(
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
                    labels[0],
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
                  child: Text(labels[1],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text('SNO-Argo-France',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                      onTap: () => launch(
                          'https://www.umr-lops.fr/SNO-Argo/SNO-Argo-France')),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text('Argo France',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                      onTap: () => launch('http://www.argo-france.fr/')),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text('Argo international',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                      onTap: () => launch('http://www.argo.ucsd.edu/')),
                ),
                Container(
                  height: 30,
                  color: Colors.white,
                  child: new InkWell(
                      child: new Text('Argo data management',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                      onTap: () => launch('http://www.argodatamgt.org/')),
                )
              ],
            );
          }
        });
  }
}
