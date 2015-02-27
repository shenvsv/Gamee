--
-- Author: bacoo
-- Date: 2014-07-20 20:15:30
--
local Gamee_6_Level = {}

local color = {ccc3(90,187,218),ccc3(145,101,176),ccc3(119, 194,152),ccc3(255,206,100),ccc3(250,116,108),ccc3(113,141,191),ccc3(164,84,125),ccc3(223,142,88),ccc3(34,47,100)}
local index = 0

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 320},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 220},
        {size = CCSize(30, 40),x = 400},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 150},
        {size = CCSize(30, 40),x = 300},
        {size = CCSize(30, 40),x = 450},
        {size = CCSize(30, 40),x = 600},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(50, 30),x = 200},
        {size = CCSize(50, 30),x = 400},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 140},
        {size = CCSize(30, 30),x = 400},
        {size = CCSize(30, 30),x = 600},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 170},
        {size = CCSize(30, 30),x = 330},
        {size = CCSize(30, 30),x = 460},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 140},
        {size = CCSize(30, 49),x = 320},
        {size = CCSize(30, 30),x = 500},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "speed",
    child = {
        {size = CCSize(30, 30),x = 170},
        {size = CCSize(30, 30),x = 430},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "speed",
    child = {
        {size = CCSize(30, 30),x = 200},
        {size = CCSize(120, 35),x = 500},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "speed",
    child = {
        {size = CCSize(30, 30),x = 200},
        {size = CCSize(100, 40),x = 360,y=50},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(50, 30),x = 230,action = {"scale",0.2,0.6,2.5}},
        {size = CCSize(50, 30),x = 400,action = {"scale",0.2,0.6,2.5}}
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 45),x = 150},
        {size = CCSize(30, 20),x = 350},
        {size = CCSize(30, 10),x = 460},
        {size = CCSize(30, 30),x = 480},
        {size = CCSize(25, 49),x = 500},
    }
}



Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 20),x = 150},
        {size = CCSize(30, 20),x = 250},
        {size = CCSize(30, 20),x = 500,action = {"scale",0.2,1,4.8}},
    }
}




Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 20),x = 200,action ={"jump",35,0.7}},
        {size = CCSize(30, 20),x = 400,action ={"jump",37,0.2}},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(60, 30),x = 200},
        {size = CCSize(60, 30),x = 305,y = 40},
        {size = CCSize(70, 30),x = 430},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "grav",
    child = {
        {size = CCSize(30, 30),x = 200},
        {size = CCSize(30, 30),x = 350,y = 145},
        {size = CCSize(30, 30),x = 400},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(100, 10),x = 200},
        {size = CCSize(118, 5),x = 390},
    }
}





Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(60, 30),x = 200,action = {"scale",0.2,0.6,2.3}},
        {size = CCSize(30, 30),x = 340,action = {"scale",0.2,1.4,2.3}},
        {size = CCSize(40, 30),x = 480,action = {"scale",0.2,0.6,2.3}},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "grav",
    child = {
        {size = CCSize(30, 30),x = 200,y = 145,action = {"moveby",1,150,0}},
        {size = CCSize(30, 30),x = 300,action = {"moveby",1,150,0}},
        {size = CCSize(30, 30),x = 400,y = 145,action = {"moveby",1,150,0}},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 200},
        {size = CCSize(30, 30),x = 270,y=40},
        {size = CCSize(30, 30),x = 340},
        {size = CCSize(30, 30),x = 480},
    }
}



Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "grav",
    child = {
        {size = CCSize(30, 30),x = 200},
        {size = CCSize(30, 30),x = 250,y = 145},
        {size = CCSize(30, 30),x = 300},
        {size = CCSize(30, 30),x = 350,y = 145},
        {size = CCSize(30, 30),x = 400},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "grav",
    child = {
        {size = CCSize(30, 30),x = 180},
        {size = CCSize(30, 30),x = 200,y = 145},
        {size = CCSize(30, 30),x = 400,y = 145},
        {size = CCSize(30, 30),x = 420},
    }
}








Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "grav",
    child = {
        {size = CCSize(30, 30),x = 100,y = 145,action = {"moveby",0.8,500,0}},
        {size = CCSize(30, 30),x = 300,action = {"moveby",1,150,0}},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "move",
    child = {
        {size = CCSize(30, 80),x = 300,y=-20,action = {"scale",0.8,1,0}}
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "move",
    child = {
        {size = CCSize(30, 80),x = 200,y=-20,action = {"scale",0.8,1,0}},
        {size = CCSize(30, 80),x = 500,y=-20,action = {"scale",1,1,0}}
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "move",
    child = {
        {size = CCSize(30, 80),x = 200,y=-20,action = {"scale",0.7,1,0}},
        {size = CCSize(30, 80),x = 350,y=-20,action = {"scale",0.8,1,0}},
        {size = CCSize(30, 120),x = 500,y=-20,action = {"scale",1,1,0}}
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    model = "move",
    child = {
        {size = CCSize(30, 80),x = 200,y=-20,action = {"scale",0.7,1,0}},
        {size = CCSize(30, 80),x = 350,y=-20,action = {"scale",0.8,1,0}},
        {size = CCSize(30, 120),x = 500,y=-20,action = {"scale",1,1,0}}
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 200},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}

Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 200},
    }
}


Gamee_6_Level[#Gamee_6_Level+1] = {
    color = color[((#Gamee_6_Level)%(#color)+1)],
    child = {
        {size = CCSize(30, 30),x = 300},
    }
}

return Gamee_6_Level