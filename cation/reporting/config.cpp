/*
    File: config.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Config file for reporting system. 
*/
#include "phone.hpp"
#include "tablet.hpp"
class Cation_Reporting {

    class language {
        #include "language.cpp"
    };

    DebugMode = 1; // Debug mode (0 = off | 1 = on)

    version = 5; // version 3.x - 4.3 -> 3 | version 4.4+ -> 4 | version 5.x -> 5

    // first status at join
    statusAtJoinIndepent = "2";
    statusAtJoinWest = "2";

    controlCenterMinLevelIndependent = 4; // min level to access control center from indepentent playerside
    controlCenterMinLevelWest = 6; // min level to access control center from west playerside

    statusIndependentVehicle[] = { // status unit - control center (INDEPENDENT)
        // {"status","variable"}, // comma
        {"0","emergency"},
        {"1","operationalByRadio"},
        {"2","operationalOnWatch"},
        {"3","tookUpAssignment"},
        {"4","arrivalAtPlaceOfAction"},
        {"5","requestToTalk"},
        {"6","notReady"},
        {"7","pickedUpPatient"},
        {"8","atTransportTarget"},
        {"9","doctorCollected"} // no comma
    };

    statusWestVehicle[] = { // Status unit - control center (WEST)
        {"0","emergency"},
        {"1","operationalByRadio"},
        {"2","operationalOnWatch"},
        {"3","tookUpAssignment"},
        {"4","arrivalAtPlaceOfAction"},
        {"5","requestToTalk"},
        {"6","temporaryAbandon"},
        {"7","informationRequest"},
        {"8","tookUpAssignment"},
        {"9","registerAbadon"}
    };

    statusIndependentCenter[] = { // Status control center - unit (INDEPENDENT)
        {"A","bannerCry"},
        {"E","abort"},
        {"C","contactForOperationalTakeover"},
        {"F","callMe"},
        {"H","comeToGuardhouse"},
        {"J","promptToTalk"},
        {"L","giveSituationReport"},
        {"P","applicationWithCops"},
        {"U","notAllowedStatus"},
        {"c","correctStatus"},
        {"d","giveTransportTarget"},
        {"h","HospitalContacted"},
        {"o","InquiryStationTaken"},
        {"u","negative"}
    };

    statusWestCenter[] = { // Status control center - unit (WEST)
        {"A","bannerCry"},
        {"E","selfProtection"},
        {"C","foreignListeners"},
        {"F","callMe"},
        {"H","warrent"},
        {"J","promptToTalk"},
        {"L","giveSituationReport"}
    };
};