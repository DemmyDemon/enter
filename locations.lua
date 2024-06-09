LOCATIONS = {
    {
        -- Elkridge Hotel, Mission Row
        label = "the Elkridge Hotel",
        door = vec4(288.876,-919.288,29.473,71.563),
        range = 1.5,
        cam = {coords=vec3(247.355,-935.042,59.695), rot=vec3(-25.322,0.000,-76.126)},
        inside = vec3(304.710,-923.719,45.033),
        enterEvent = {'chat:addMessage', { color = {255, 255, 0}, args = {"Hotel", "Checking in"}} },
        exitEvent = {'chat:addMessage', { color = {255, 255, 0}, args = {"Hotel", "Checking out"}} },
    },
    {
        -- Grain of Truth, Morningwood
        door = vec4(-1412.124,-320.180,44.384,89.712),
        cam = vec3(-1426.340,-326.560,54.390),
        inside = vec3(-1407.491,-319.769,44.179),
        enterEvent = {'chat:addMessage', { color = {255, 255, 0}, args = {"Hiding", "Entered The Grain of Truth"}} },
        exitEvent = {'chat:addMessage', { color = {255, 255, 0}, args = {"Hiding", "Exited The Grain of Truth"}} },
        -- wait = 0,
        --suppressExit = true,
    },
    {
        -- Mighty Bush, Morningwood
        door = vec4(-1582.667,-234.803,54.846,62.825),
        cam = vec3(-1603.211,-237.672,68.352),
        inside = vec3(-1577.519,-236.915,54.424),
    },
    {
        -- Old Swedish Paradise meth lab
        door = vec4(-1579.519,-440.607,38.178,230.227),
        cam = {coords=vec3(-1579.626,-441.399,40.419), rot=vec3(-30.986,-0.000,-68.947)},
        inside = vec3(-1584.942,-438.269,37.925),
        nightvision = true,
    },
    {
        -- Some random door in Morningwood
        door = vec4(-1569.399,-233.240,49.467,241.643),
        cam = {coords=vec3(-1561.988,-235.056,53.170), rot=vec3(-18.589,0.000,105.128)},
        inside = vec3(-1571.705, -231.531, 48.466),
    },
    {
        -- Some random hose in the canals
        door = vec4(-1022.175,-1023.115,2.150,28.924),
        cam = vec3(-1021.051,-997.518,20.284),
        inside = vec3(-1017.436,-1027.824,5.011),
    },
    {
        -- Appartment building in Vpespucci
        door = vec4(-1285.264,-1253.204,4.430,289.035),
        cam = {coords=vec3(-1268.480,-1279.424,29.044), rot=vec3(-36.906,0.000,42.891)},
        inside = vec3(-1290.477, -1248.356, 10.126),
    },
    {
        -- Yum Fish, Strawberry
        door = vec4(95.669,-1682.587,29.256,138.063),
        cam = vec3(83.667,-1688.029,38.933),
        inside = vec3(99.715,-1678.015,30.309),
        enterEvent = 'fishy:sell-fish-menu',
        exitEvent = 'fishy:close-menu',
        wait = 0,
    },
    {
        -- Chringo's Carpets, Strawberry
        door = vec4(125.536,-1705.005,29.292,139.690),
    },
    {
        -- Emergency entrance, Central Los Santos Medical Center, Davis
        door = vec4(294.228,-1448.793,29.967,318.980),
        cam = vec3(253.232,-1464.020,56.747),
        inside = vec3(301.000,-1459.805,31.965),
        range = 2.5,
    },
    {
        -- Berts Tool Supply (back door)
        door = vec4(341.346,-1270.677,31.975,90.439),
        cam = vec3(334.613,-1312.172,40.426),
        inside = vec3(346.903,-1283.176,32.594),
    },
    {
        -- Attack-a-taco
        door = vec4(445.946,-1241.794,30.281,179.840),
        cam = {coords=vec3(430.654,-1251.475,38.298), rot=vec3(-16.191,0.000,-54.608)},
        inside = vec3(451.022,-1239.326,30.629),
        wait = 0,
    },
    {
        -- Mission Row appartments
        door = vec4(288.314,-1094.941,29.423,273.191),
        cam = {coords=vec3(290.272,-1100.338,50.059), rot=vec3(-74.566,0.000,-44.060)},
        inside = vec3(287.106,-1098.186,50.867),
        range = 2.0,
        blur = true,
    },
    {
        -- Maze Bank
        door = vec4(-68.681,-801.051,44.227,339.739),
        range = 5.0,
        cam = vec3(-59.772,-777.529,322.695),
        inside = vec3(-75.266,-820.078,318.621),
        dof = {25.0, 50.0},
        state = {job = {"banker", "police"}},
    },
    {
        -- Some house in Vinewood Hills
        door = vec4(-189.317,617.818,199.666,182.796),
        cam = vec3(-204.328,592.915,226.795),
        inside = vec3(-182.731,631.632,199.315),
        state = {job = {"laywer", "hoerz"}},
    },
    {
        -- La Mesa police precinct
        door = vec4(827.443,-1290.057,28.246,89.455),
        cam = vec3(809.659,-1261.422,47.347),
        inside = vec3(839.259,-1290.804,27.246),
        wait = 0,
        state = {job = "police"},
    },
    {
        -- h4x office
        label = "h4x Office",
        door = vec4(109.372,-1090.524,29.302,339.981),
        cam = {coords=vec3(106.318,-1085.358,33.335), rot=vec3(-24.239,0.000,-53.525)},
        multicam = {
            {coords=vec3(126.508,-1087.380,34.628), rot=vec3(-21.395,0.000,60.334)},
            {coords=vec3(128.258,-1086.294,34.660), rot=vec3(-20.883,0.000,-29.467)},
        },
        inside = vec3(105.106,-1100.647,31.301),
        nightvision = true,
        range = 1.5,
    },
    {
        -- carwash
        door = vec4(-1.308,-1400.364,29.271,91.291),
        cam = {coords=vec3(-4.252,-1400.991,34.127), rot=vec3(-14.408,-0.000,59.953)},
        multicam = {
            {coords=vec3(-3.341,-1401.798,33.895), rot=vec3(-21.495,0.000,-147.879)},
            {coords=vec3(42.008,-1398.702,34.100), rot=vec3(-16.809,0.000,-121.968)},
        },
        inside = vec3(3.519,-1399.908,29.671),
        nightvision = true,
    },
    {
        -- Ye Olde HQ
        door = vec4(105.284,-1569.441,29.734,317.380),
        cam = {coords=vec3(108.214,-1560.288,33.577), rot=vec3(-29.227,-0.000,-74.470)},
        nightvision = true,
        inside = vec3(101.501,-1573.540,30.580),
    },
    {
        -- Ron gas station
        door = vec4(152.326,-1557.438,29.262,134.812),
        cam = {coords=vec3(174.242,-1591.307,46.653), rot=vec3(-26.606,0.000,3.354)},
        inside = vec3(158.231,-1551.823,30.590),
    },
    {
        -- Random house in Rancho
        door = vec4(300.081,-1783.803,28.444,138.575),
        cam = {coords=vec3(301.811,-1793.454,38.598), rot=vec3(-41.222,-0.000,23.387)},
        inside = vec3(294.269,-1779.195,28.930),
    },
    {
        -- Warehouse
        door = vec4(1192.447,-1249.195,40.321,0.343),
        cam = {coords=vec3(1194.528,-1249.847,42.781), rot=vec3(-30.886,0.000,-121.860)},
        multicam = {
            {coords=vec3(1194.611,-1255.584,42.800), rot=vec3(-29.901,0.000,-58.278)},
            {coords=vec3(1214.982,-1266.879,40.359), rot=vec3(-18.366,0.000,143.563)},
            {coords=vec3(1215.194,-1281.403,42.185), rot=vec3(-25.570,0.000,52.933)},
            {coords=vec3(1194.210,-1276.056,38.834), rot=vec3(-21.830,0.000,-65.336)},
        },
        inside = vec3(1186.867,-1253.063,41.514),
        nightvision = true,
    },
    {
        -- The old MC hangout
        door = vec4(-1471.832,-920.179,10.025,229.241),
        cam = {coords=vec3(-1454.145,-925.028,23.080), rot=vec3(-35.288,0.000,91.016)},
        inside = vec3(-1477.020,-918.120,10.237),
    },
    {
        -- Pier flat
        door = vec4(-1577.708,-970.502,17.412,141.375),
        cam = vec3(-1586.500,-968.248,20.613),
        inside = vec3(-1574.378,-968.964,17.797),
    },
    {
        -- Pearl's
        door = vec4(-1816.671,-1193.587,14.310,333.069),
        cam = {coords=vec3(-1797.565,-1178.053,33.962), rot=vec3(-33.612,0.000,114.252)},
        inside = vec3(-1828.672,-1193.147,16.867),
    },
    {
        -- Pelle's Plåt & Punk
        door = vec4(722.891,-1069.464,23.067,93.566),
        cam = vec3(717.343,-1060.850,26.153),
        inside = vec3(726.459,-1072.813,19.758),
    },
}
