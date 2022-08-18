/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for trade system. 
*/
class Cation_Trade {
    tag = "cat_trade";
    class functions {
        file = "cation\trade";        
        // Client        
        class abort {};
        class addBuyer {};
        class delVendor {};
        class getText {};
        class index {};
        class init { postInit = 1; };
        class isNumber {};
        class openBuyer {};
        class openVendor {};
        class openVendorLBItemChange {};
        class openVendorLBTypeChange {};
        class removeFromKeyChain {};
        class signBuyer {};
        class signVendor {};
        class StrToArray {};
        // Server
        class editServer {};
        // HC
        class editServerHC {};
    };
};