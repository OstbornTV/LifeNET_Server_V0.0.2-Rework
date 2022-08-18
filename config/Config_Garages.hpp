/*
    Anything defined in Config_Garages is strictly just a garage, it will not act like a house.

    price - Cost of the garage
    garageSpawnPos[] - worldToModel position to spawn vehicles
    garageSpawnDir - Offset to garage direction to spawn at (+-90 etc). It will be used in the manner: getDir _garage + spawnDir
    garageBlacklists[] - List of blacklisted houses for buying garages
        default: {}
*/

class Garages 
{

    class Altis 
    {

        class Land_i_Garage_V1_F 
        {
            price = 500000;
            garageSpawnPos[] = {-11.5,0,0};
            garageSpawnDir = -90;
            garageBlacklists[] = {};
        };

        class Land_i_Garage_V2_F : Land_i_Garage_V1_F{};

    };

    class Tanoa 
    {

        class Land_SM_01_shed_F 
        {
            price = 140000;
            garageSpawnPos[] = {-11.404,3.81494,-1.64553};
            garageSpawnDir = 0;
            garageBlacklists[] = {};
        };

        class Land_i_Shed_Ind_F : Land_SM_01_shed_F 
        {
            garageBlacklists[] = {{3078.71,11012.1,0.119904}};
        };
        
    };

    class Rosche {

        class Land_WL_House_05_A {
            price = 100000;
            garageSpawnPos[] = {0,0,0};
            garageSpawnDir = 20;
            garageBlacklists[] = {};
        };
    };
};