playableInZone = false;
emitters = [];

player addEventHandler  
[ 
   "Killed", 
   { 
		playableInZone = false;
       _newGrp = createGroup CIVILIAN; 
       [(_this select 0)] joinSilent _newGrp; 
   } 
];  
