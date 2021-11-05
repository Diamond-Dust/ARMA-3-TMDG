player addEventHandler  
[ 
   "Respawn", 
   { 
		playableInZone = false;
       if (side (_this select 0) isEqualTo INDEPENDENT) then 
       { 
           _newGrp = createGroup CIVILIAN; 
           [(_this select 0)] joinSilent _newGrp; 
       } 
       else 
       { 
           if (side (_this select 0) isEqualTo EAST) then 
           { 
               _newGrp = createGroup CIVILIAN; 
               [(_this select 0)] joinSilent _newGrp; 
           }; 
       };   
   } 
];  