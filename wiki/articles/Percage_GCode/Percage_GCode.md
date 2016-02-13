#Pilotage du percage de cartons en utilisant les GCodes (Arduino + GRBL) 

*2015 - 2016* - Article rédigé par Patrice Freydiere et Jean Pierre Rosset

*Janvier 2016* - Ajout d'élément de Freddy sur l'apprentissage de la configuration GRBL par Freddy.



##Introduction 


Cette année 2015 - 2016, Jean Pierre Rosset a réalisé une perforatrice automatique pour carton, en utilisant le meilleure de la technologie actuelle. Fort des projets Open Source Existants, le lien entre la machine outil et l'ordinateur se trouve grandement simplifié, améliorant de fait la fiabilité du pilotage.

![](perfo_35r.jpg)

Dans les grandes ligne, sa machine , autonome, utilise un arduino pour la gestion des déplacements et problematiques electronique, laissant alors soin à un pilotage CNC utilisant les GCODE. 

Cette approche avait également été évoquée par Pierre Penard lors de discussions. Jean Pierre Rosset l'a fait !

_Principes de la machine :_

![](synoptic.png)


La machine est autonome en fonctionnement, l'ordinateur envoie des commandes de déplacement, et de perçage en utilisant une liaison série. Donc plus de perte de pas, et une adaptation simple aux machines existantes. En effet, le paramétrage de l'arduino, permet de positionner une référence, et un certains nombre de paramètres relatifs à la machine. 
L'ordinateur n'a alors plus besoin de connaitre les détails de construction, et de pilotage, en envoyant des commandes génériques comme une machine à commande numérique.

Le projet open source GRBL conçu pour Arduino, implémente un certain nombre de fonctionnalités :

- Gestion des types de commandes
- Gestion des accélérations, déplacements
- Gestion des références (homing)


[Références des pièces utilisées pour la construction de la machine](PIECES_POUR_CONSTRUCTION_PERFORATRICE.pdf) 

##Logiciel spécialisé pour les machines CNC à perforation de carton

Dans le cadre du projet, le logiciel GRBL a été modifié pour les machines à perforation, plusieures modifications ont été mise en place :

- mise en place d'un détecteur pour les état poinçons haut et bas
- Nouvelle commande GCODE M100, permettant de déclencher un coup de poinçon 

le projet dérivé de GRBL - GRBLPunch est disponible et TELECHARGEABLE à cette adresse : [https://github.com/frett27/grblPunch](https://github.com/frett27/grblPunch)

##Mise en place de la partie logicielle de commande par l'arduino

La mise en place passe par plusieures étapes, 

1 - récupérer le fichier grblpunch.hex dans le projet : [Fichier grblpunch.hex](https://github.com/frett27/grblPunch)

2 - Utilisez le logiciel [XLoader](XLoader.zip) pour charger le fichier dans l'arduino

![xloader.PNG](xloader.PNG)



##Configuration

Une fois le chargement du programme réalisé, l'outil UniversalGCodeSender, permet d'ouvrir une console sur l'arduino afin de pouvoir paramétrer GBRL.

![](UGCODESender.PNG)

les commandes peuvent être lancées depuis la boite commande, 

le paramétrage des commandes suit ces indications : [https://github.com/grbl/grbl/wiki/Configuring-Grbl-v0.9](https://github.com/grbl/grbl/wiki/Configuring-Grbl-v0.9)

**Note** : Freddy réalisé une traduction de l'ensemble des paramètres,
 
<a href="PARAMÈTRES DU GRBL_JPR_Freddy.pdf">
![Parametrage GRBL](ManuelParametres.PNG)
</a>



dans notre cas, nous avons paramétré le système en utilisant ces résultat: (resultat de la commande $$)

[Parametres complets de Jean Pierre utilisé en production](Paramétres_KRUNCH_fév-2016.pdf)


#Et le carton alors ???

APrint nous permet dans une 1ere étape la génération d'un fichier GCode, pouvant être envoyé sur la machine pour perçage. le script suivant, pouvant être adapté permet l'export des commandes de perforation dans un fichier GCode.

	
	
	import org.barrelorgandiscovery.gui.atrace.*
	import org.barrelorgandiscovery.gui.aedit.*
	import java.awt.*
	import java.awt.geom.* // point2D
	
	def pconverter = new PunchConverter(virtualbook.scale, 3.2, 2) // poincon de 3mm par 3mm
	
	def punchConvertionResult = pconverter.convert(virtualbook.holesCopy)
	// punch convertionResult contient les erreur et la liste des coups de poincons Ã  donner (avec Ã©ventuellement un recouvrement)
	
	
	
	println punchConvertionResult.holeerrors
	
	def punches = punchConvertionResult.result
	
	// pour chaque coup de poincons, on ecrit les ordres pour la machine
	
	c = 0
	punches.each {
	   println "N${c++} G90 X${it.y-1.0} Y${it.x}"
	   println "M100"
	}
	
	// visualisation sur le carton des coups de poinÃ§ons
	
	// crÃ©ation d'un calque pour visionner le resultat
	def g = new GraphicsLayer("poincon")
	g.setStroke(new BasicStroke(0.4f));
	
	// on recupere la gamme de l'instrument
	def scale = virtualbook.scale
	
	// on enleve des graphiques du calque si necessaire, lorsqu'on lance plusieurs fois le script
	g.clear()
	
	// on ajoute les coup de poinÃ§on au calque pour les visualiser
	// les coordonnes du coup de poincon sont au centre du poincon, il faut prendre en charge
	// le referentiel de position
	
	// scale.trackwidth est la largeur de la piste (en y)
	
	punches.each {
	    g.add(new Rectangle2D.Double(it.x - 2.0,it.y - scale.trackWidth / 2.0, 4.0, scale.trackWidth))
	}
	
	// on ajoute le calque
	pianoroll.addOrReplaceLayer(g)
	// on rafraichit la fenetre
	pianoroll.repaint()


