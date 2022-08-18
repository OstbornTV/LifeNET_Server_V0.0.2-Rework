/*
    File: language.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Language config for management system. 
    You can add more translations - the following languages are supported by ArmA 3:
    English, Czech, French, Spanish, Italian, Polish, Portuguese, Russian, German, Korean, Japanese
*/
defaultLanguage = "English";

class English {
    messageSenderDeg = "You have degreaded %2. His/Her new rank is %1.";
    messageReceiverDeg = "You were degraded. Your new rank is %1. Your identification badge will be updated after your next resapwn.";
    messageSenderPro = "You have promoted %2. His/Her new rank is %1.";
    messageReceiverPro = "You were promoted. Your new rank is %1. Your identification badge will be updated after your next resapwn.";
    messageSenderFired = "You have fired %1.";
    messageReceiverFired = "You were fired. You will lose your identification badge after your next respawn.";
    messageSenderMoney = "You gave %1 %2%3.";
    messageReceiverMoney = "%1 have gave you %2%3.";
    messageSenderLicAdd = "You have added %1 to %2.";
    messageReceiverLicAdd = "%2 gave you the %1.";
    messageSenderLicWithdraw = "You have withdrawed %1 from %2.";
    messageReceiverLicWithdraw = "%2 have revoked your %1.";
    ok = "ok";
    playername = "Playername:";
    rank = "Current rank:";
    changeRank = "Change rank to";
    administration = "Administration";
    fire = "fire";
    currency = "$";
    giveLicence = "Give licence";
    licences = "Licences:";
    withdrawLicence = "Withdraw licence";
    hire = "hire";
    giveMoney = "Give money";
    changes = "These changes will take some seconds!";
    receivingData = "Receiving data ...";
    moneyFail = "You can not go above $999,999!";
    notEnoughMoney = "You don't have that much money with you.";
};

class German {
    messageSenderDeg = "Du hast %2 degradiert. Seine neue Dienststufe ist %1.";
    messageReceiverDeg = "Du wurdest degradiert. Deine neue Dienststufe ist %1. Dein Ausweiß für deine neue Position wird nach erneutem Aufwachen fertig sein.";
    messageSenderPro = "Du hast %2 befördert. Seine neue Dienststufe ist %1.";
    messageReceiverPro = "Du wurdest befördert. Deine neue Dienststufe ist %1. Dein Ausweiß für deine neue Position wird nach erneutem Aufwachen fertig sein.";
    messageSenderFired = "Du hast %1 gefeuert.";
    messageReceiverFired = "Du wurdest gefeuert. Deine Ausweiß wird dir spätestens bis zum erneuten Aufwachen abgenommen.";
    messageSenderMoney = "Du hast %1 %2%3 gegeben.";
    messageReceiverMoney = "%1 hat dir %2%3 gegeben.";
    messageSenderLicAdd = "Du hast %2 den %1 gegeben.";
    messageReceiverLicAdd = "%2 hat dir einen %1 ausgestellt.";
    messageSenderLicWithdraw = "Du hast %2 den %1 entzogen.";
    messageReceiverLicWithdraw = "%2 hat dir den %1 entzogen.";
    ok = "ok";
    playername = "Spielername:";
    rank = "Aktueller Rang:";
    changeRank = "Rang ändern zu";
    administration = "Verwaltung";
    fire = "feuern";
    currency = "€";
    giveLicence = "Lizenz erteilen";
    licences = "Lizenzen:";
    withdrawLicence = "Lizenz entziehen";
    hire = "einstellen";
    giveMoney = "Geld geben";
    changes = "Änderungen werden vollzogen ... Bitte habe ein paar Sekunden Gedult!";
    receivingData = "Empfange Daten ...";
    moneyFail = "Maximaler Wert 999.999€!";
    notEnoughMoney = "Du hast nicht so viel Geld dabei.";
};