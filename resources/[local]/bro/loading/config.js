/*
    This script was developed by Piter Van Rujpen/TheGamerRespow for Vulkanoa (https://discord.gg/bzMnYPS).
    Do not re-upload this script without my authorization. (I only give authorization by PM on FiveM.net (https://forum.fivem.net/u/TheGamerRespow))
*/

var VK = new Object(); // DO NOT CHANGE
VK.server = new Object(); // DO NOT CHANGE

VK.backgrounds = new Object(); // DO NOT CHANGE
VK.backgrounds.actual = 0; // DO NOT CHANGE
VK.backgrounds.way = true; // DO NOT CHANGE
VK.config = new Object(); // DO NOT CHANGE
VK.tips = new Object(); // DO NOT CHANGE
VK.music = new Object(); // DO NOT CHANGE
VK.info = new Object(); // DO NOT CHANGE
VK.social = new Object(); // DO NOT CHANGE
VK.players = new Object(); // DO NOT CHANGE 

//////////////////////////////// CONFIG

VK.config.loadingSessionText = "Chargement de la session..."; // Loading session text
VK.config.firstColor = [0, 191, 255]; // First color in rgb : [r, g, b]
VK.config.secondColor = [255, 150, 0]; // Second color in rgb : [r, g, b]
VK.config.thirdColor = [52, 152, 219]; // Third color in rgb : [r, g, b]

VK.backgrounds.list = [ // Backgrounds list, can be on local or distant(http://....)
    "img/1.jpg",
    "img/2.jpg",
    "img/3.jpg"
];
VK.backgrounds.duration = 5000; // Background duration (in ms) before transition (the transition lasts 1/3 of this time)

VK.tips.enable = true; //Enable tips (true : enable, false : prevent)
VK.tips.list = [ // Tips list
    "Maintenez \"X\" pour mettre vos mains en l'air !",
    "Sois un vrai bro, et vote pour le serveur !",
    "Restez fair-play",
    "Tu vois un bug ? Report le sur discord",
    "Car-kill tu ne fera point",
    "Le NO-FEAR RP c'est pas juste dans les films, ne le fais pas !",
    "Abonne toi à la chaine de BrocoliPasFrais",
];

VK.music.url = "music.wav"; // Music url, can be on local or distant(http://....) ("NONE" to desactive music)
VK.music.volume = 0.1; // Music volume (0-1)
VK.music.title = "StreamBeats"; // Music title ("NONE" to desactive)
VK.music.submitedBy = "NONE"; // Music submited by... ("NONE" to desactive)

VK.info.logo = "NONE"; // Logo, can be on local or distant(http://....) ("NONE" to desactive)
VK.info.text = "Fondé et développé par BrocoliPasFrais"; // Bottom right corner text ("NONE" to desactive) 
VK.info.website = "http://twitch.tv/brocolipasfrais"; // Website url ("NONE" to desactive) 
VK.info.ip = "51.178.86.118:40120"; // Your server ip and port ("ip:port")

VK.social.discord = ".gg/MVD9bF9G"; // Discord url ("NONE" to desactive)
VK.social.twitter = "/brocolipasfrais"; // Twitter url ("NONE" to desactive)
VK.social.facebook = "/brocolipasfrais"; // Facebook url ("NONE" to desactive)
VK.social.youtube = "/brocolipasfrais"; // Youtube url ("NONE" to desactive)
VK.social.twitch = "/brocolipasfrais"; // Twitch url ("NONE" to desactive)

VK.players.enable = true; // Enable the players count of the server (true : enable, false : prevent)
VK.players.multiplePlayersOnline = "@players joueurs en ligne"; // @players equals the players count
VK.players.onePlayerOnline = "1 joueur en ligne"; // Text when only one player is on the server
VK.players.noPlayerOnline = "Aucun joueur en ligne"; // Text when the server is empty

////////////////////////////////
