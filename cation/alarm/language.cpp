/*
    File: language.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Language config for security system. 
    You can add more translations - the following languages are supported by ArmA 3:
    English, Czech, French, Spanish, Italian, Polish, Portuguese, Russian, German, Korean, Japanese
*/
defaultLanguage = "English";

class English {
    alarmMarkerText = "Alarm triggered!";
    alarmMessage = "In your house %1 near %2 the alarm was triggered!";
    securitySystem = "Securitysystem";
    securityInstall = "Install Securitysystem for $%1?";
    buy = "Buy";
    cancel = "Close";
    securityAlreadyInstalled = "This building already owns a Securitysystem!";
    NotEnoughMoney = "You don't have enought money!";
    secured = "secured";
    resetAlarm = "Reset Securitysystem";
    buyAlarm = "Buy Securitysystem";
};

class German {
    alarmMarkerText = "Alarm ausgelöst!";
    alarmMessage = "In deinem %1 bei %2 wurde der Alarm ausgelöst!";
    securitySystem = "Sicherheitssystem";
    securityInstall = "Sicherheitssystem für %1€ installieren?";
    buy = "Kaufen";
    cancel = "Schließen";
    securityAlreadyInstalled = "In diesem Gebäude wurde bereits ein Sicherheitssystem installiert!";
    NotEnoughMoney = "Du hast nicht genügend Geld!";
    secured = "alarmgesichert";
    resetAlarm = "Alarmanlage zurücksetzen";
    buyAlarm = "Alarmanlage kaufen";
};