/*
*   class:
*       MaterialsReq (Needed to process) = Array - Format -> {{"ITEM CLASS",HOWMANY}}
*       MaterialsGive (Returned items) = Array - Format -> {{"ITEM CLASS",HOWMANY}}
*       Text (Progess Bar Text) = Localised String
*       NoLicenseCost (Cost to process w/o license) = Scalar
*
*   Example for multiprocess:
*
*   class Example {
*       MaterialsReq[] = {{"cocaine_processed",1},{"heroin_processed",1}};
*       MaterialsGive[] = {{"diamond_cut",1}};
*       Text = "STR_Process_Example";
*       //ScrollText = "Process Example";
*       NoLicenseCost = 4000;
*   };
*/

class ProcessAction {
//Neu eingefügte
    class plastik_pellets {
        MaterialsReq[] = {{"oil",1}};
        MaterialsGive[] = {{"plastik_pellets",1}};
        text = "STR_Process_plastik_pellets";
        //ScrollText = "Presse Pellets";
        NoLicenseCost = -1;
    };

    class gartenstuhle {
        MaterialsReq[] = {{"plastik_pellets",1}};
        MaterialsGive[] = {{"gartenstühle",1}};
        text = "STR_Process_gartenstuhl";
        //ScrollText = "Verarbeite das Plastik zur Gartenstühle";
        NoLicenseCost = -1;
    };

    class salz_brezzel {
        MaterialsReq[] = {{"mehl",1},{"salt_refined",1}};
        MaterialsGive[] = {{"salz_brezzel"}};
        text = "STR_Process_salz_brezzel";
        //ScrollText = "Backe Salz Brezzeln";
        NoLicenseCost = -1;
    };

    class brezzel {
        MaterialsReq[] = {{"mehl",1}};
        MaterialsGive[] = {{"brezzel",1}};
        text = "STR_Process_brezzel";
        //ScrollText = "Backe Brezzeln";
        NoLicenseCost = -1;
    };

    class mehl {
        MaterialsReq[] = {{"getreide",1}};
        MaterialsGive[] = {{"mehl",1}};
        text = "STR_Process_mehl";
        //ScrollText = "Mahle Mehl";
        NoLicenseCost = -1;
    };

    class pommes {
        MaterialsReq[] = {{"kartoffeln",1}};
        MaterialsGive[] = {{"tüte_pommes",1}};
        text = "STR_Process_pommes";
        //ScrollText = "Scheinde Kartoffeln klein";
        NoLicenseCost = -1;
    };

    class kies {
        MaterialsReq[] = {{"rock",1}};
        MaterialsGive[] = {{"kies",1}};
        text = "STR_Process_kies";
        //ScrollText = "Mahle stein zu Kies";
        NoLicenseCost = -1;
    };

    class farbstoff {
        MaterialsReq[] = {{"oil",1}};
        MaterialsGive[] = {{"farbstoff",1}};
        text = "STR_Process_farbstoff";
        //ScrollText = "Vermische die Farben";
        NoLicenseCost = -1;
    };

    class reifen {
        MaterialsReq[] = {{"kautschuck",1},{"oil",1}};
        MaterialsGive[] = {{"reifen",1}};
        text = "STR_Process_Reifen";
        //ScrollText = "Stelle Reifen her";
        NoLicenseCost = -1;    
    };

    class susswaren {
        MaterialsReq[] = {{"zucker",2}};
        MaterialsGive[] = {{"susswaren_processed",1}};
        Text = "STR_Process_susswaren";
        //ScrollText = "Stelle Süwaren her aus dem Zucker";
        NoLicenseCost = -1;
	};

    class zucker {
        MaterialsReq[] = {{"zucker_unprocessed",4}};
        MaterialsGive[] = {{"zucker_processed",1}};
        Text = "STR_Process_zucker";
        //ScrollText = "Verarbeite die Zuckerrüben zur zucker";
        NoLicenseCost = -1;
	};

 //Alte routen
    class diamond {
        MaterialsReq[] = {{"diamond_uncut",1}};
        MaterialsGive[] = {{"diamond_cut",1}};
        Text = "STR_Process_Diamond";
        //ScrollText = "Cut Diamonds";
        NoLicenseCost = 1350;
    };

    class heroin {
        MaterialsReq[] = {{"heroin_unprocessed",1}};
        MaterialsGive[] = {{"heroin_processed",1}};
        Text = "STR_Process_Heroin";
        //ScrollText = "Process Heroin";
        NoLicenseCost = 1750;
    };

    class copper {
        MaterialsReq[] = {{"copper_unrefined",1}};
        MaterialsGive[] = {{"copper_refined",1}};
        Text = "STR_Process_Copper";
        //ScrollText = "Refine Copper";
        NoLicenseCost = 750;
    };

    class iron {
        MaterialsReq[] = {{"iron_unrefined",1}};
        MaterialsGive[] = {{"iron_refined",1}};
        Text = "STR_Process_Iron";
        //ScrollText = "Refine Iron";
        NoLicenseCost = 1120;
    };

    class sand {
        MaterialsReq[] = {{"sand",1}};
        MaterialsGive[] = {{"glass",1}};
        Text = "STR_Process_Sand";
        //ScrollText = "Melt Sand into Glass";
        NoLicenseCost = 650;
    };

    class salt {
        MaterialsReq[] = {{"salt_unrefined",1}};
        MaterialsGive[] = {{"salt_refined",1}};
        Text = "STR_Process_Salt";
        //ScrollText = "Refine Salt";
        NoLicenseCost = 450;
    };

    class cocaine {
        MaterialsReq[] = {{"cocaine_unprocessed",1}};
        MaterialsGive[] = {{"cocaine_processed",1}};
        Text = "STR_Process_Cocaine";
        //ScrollText = "Process Cocaine";
        NoLicenseCost = 1500;
    };

    class marijuana {
        MaterialsReq[] = {{"cannabis",1}};
        MaterialsGive[] = {{"marijuana",1}};
        Text = "STR_Process_Marijuana";
        //ScrollText = "Harvest Marijuana";
        NoLicenseCost = 500;
    };

    class zement {
        MaterialsReq[] = {{"sand",1}};
        MaterialsGive[] = {{"zement",1}};
        Text = "STR_Process_Cement";
        //ScrollText = "Mix Cement";
        NoLicenseCost = 350;
    };
};
