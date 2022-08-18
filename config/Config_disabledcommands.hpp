
/*
    COMMANDS: FAILMISSION, ENDMISSION
*/

class cfgdisabledcommands
{
    class failmission
    {
        class syntax1
        {
            targets[] = {0,0,0};
            args[] = {{},{"STRING"}};
        };
    };
    class endmission
    {
        class syntax1
        {
            targets[] = {1,0,1};
            args[] = {{},{"STRING"}};
        };
    };
    class forceend
    {
        targets[] = {1,0,1};
    };
};
