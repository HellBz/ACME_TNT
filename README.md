# ACME_TNT
>Terrible Nuke Territory - This script bombs randomized or static locations on your map. 
***
First of all
### CREDITS

                                                                                                               
 This is an adaption from "mmmyum's animated air raid dayz"
 So all credits for this goes to mmmyum                                                                        
***                                                                                                             
 #### Special thanks to:                                                                                            
 >   **$p4rkY** --> because he is my Mentor                                                     
 >   **adR1** --> because he is my testing and translation guy                                   
 >   **Eichi** --> for helping with the TraderZone detection                                
 >   **My wife** --> for making awesome coffee                                                
 >   **Saecco Minuto** --> because thats the reason why my wife could make such awesome coffee                                                                                                                      
***
### INSTALLATION

This step is very hard, so if you are not familiar with scripting or setting up a arma 3 server with exile, I advise you to not install this on your server.....!

Just joking...

#### Step 1
Download the File, put the **__ACME_TNT.pbo__** into **__@ExileServer\addons__**

#### Step 2
If you like to have sounds of hooting sirens, put the Folder **__Sounds__** to your mission.pbo (for example **__Exile.Altis.pbo__**) Otherwise skip ***Step 3*** and go to **__ACME_TNT.pbo\server\ACME_TNT.sqf__** and set on line 69 _ambientSound to **__false__**.

#### Step 3
Open your **__discription.ext__** and add the following lines to it. If you already have an existing **__CfgSound__**, merge it to that one...
```c++
            class CfgSounds
            {
                sounds[] = {drop,siren1,siren2,siren3};
                class drop
                {
                  name="drop";
                  sound[]={\Sounds\drop.ogg,db+6,1};
                  titles[] = {};
                };
                class siren1
                {
                  name="siren1";
                  sound[]={\Sounds\siren1.ogg,db+6,1};
                  titles[] = {};
                };
                class siren2
                {
                  name="siren2";
                  sound[]={\Sounds\siren2.ogg,db+6,1};
                  titles[] = {};
                };
                class siren3
                {
                  name="siren3";
                  sound[]={\Sounds\siren3.ogg,db+6,1};
                  titles[] = {};
                };
            };
```
Done.... Thats it...

To edit settings open **__ACME_TNT\server\ACME_TNT.sqf__**
Look to the lines below **__Start Setup - change settings below to your wishes__**

Hope you have fun with it
