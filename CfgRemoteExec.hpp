// RemoteExec-Makros
#define F(NAME, TARGET) class NAME { \
    allowedTargets = TARGET; \
};

#define JIP(NAME, TARGET) class NAME { \
    allowedTargets = TARGET; \
    jip = 1; \
};

#define ANYONE 0
#define CLIENT 1
#define SERVER 2
#define HC HC_Life

class CfgRemoteExec {
    class Functions {
        mode = 1;
        jip = 0;

        //Addons
        class cxpbt_fnc_completeBugTracking {allowedTargets = 1;};
        class cxpbt_fnc_saveBugReported {allowedTargets = 2;};

        class cat_craftingV2_fnc_initPlans {allowedTargets=1;};
        class cat_craftingV2_fnc_initLevel {allowedTargets=1;};
        class cat_craftingV2_fnc_query {allowedTargets=2;};
        class cat_craftingV2_fnc_queryHC {allowedTargets=HC_Life;};
        class cat_craftingV2_fnc_updatePlans {allowedTargets=2;};
        class cat_craftingV2_fnc_updatePlansHC {allowedTargets=HC_Life;};
        class cat_craftingV2_fnc_updatePoints {allowedTargets=2;};
        class cat_craftingV2_fnc_updatePointsHC {allowedTargets=HC_Life;};
        class cat_locker_fnc_init {allowedTargets=1;};
        class cat_locker_fnc_fetchTrunk {allowedTargets=2;};
        class cat_locker_fnc_updateTrunk {allowedTargets=2;};
        class cat_locker_fnc_fetchTrunkHC {allowedTargets=HC_Life;};
        class cat_locker_fnc_updateTrunkHC {allowedTargets=HC_Life;};
        class cat_perm_fnc_getInfos {allowedTargets=2;};
        class cat_perm_fnc_updateRank {allowedTargets=2;};
        class cat_perm_fnc_getInfosHC {allowedTargets=HC_Life;};
        class cat_perm_fnc_updateRankHC {allowedTargets=HC_Life;};
        class cat_perm_fnc_updatePlayer {allowedTargets=1;};
        class cat_perm_fnc_updatePermDialog {allowedTargets=1;};
        class cat_alarm_fnc_houseAlarm {allowedTargets=1;};
        class cat_alarm_fnc_houseAlarmMarker {allowedTargets=1;};
        class cat_alarm_fnc_addSecurity {allowedTargets=2;};
        class cat_alarm_fnc_loadSecurity {allowedTargets=2;};
        class cat_alarm_fnc_addSecurityHC {allowedTargets=HC_Life;};
        class cat_alarm_fnc_loadSecurityHC {allowedTargets=HC_Life;};
        class cat_reporting_fnc_statusMessage {allowedTargets=1;};
        class cat_trade_fnc_removeFromKeyChain {allowedTargets=0;};
        class cat_trade_fnc_abort {allowedTargets=1;};
        class cat_trade_fnc_delVendor {allowedTargets=1;};
        class cat_trade_fnc_addBuyer {allowedTargets=1;};
        class cat_trade_fnc_openBuyer {allowedTargets=1;};
        class cat_trade_fnc_editServer {allowedTargets=2;};
        class cat_trade_fnc_editServerHC {allowedTargets=HC_Life;};


    /* Client only functions */
    class life_fnc_AAN {allowedTargets=CLIENT;};
    class life_fnc_addVehicle2Chain {allowedTargets=CLIENT;};
    class life_fnc_adminID {allowedTargets=CLIENT;};
    class life_fnc_adminInfo {allowedTargets=CLIENT;};
    class life_fnc_bountyReceive {allowedTargets=CLIENT;};
    class life_fnc_emergencySiren {allowedTargets=CLIENT; jip = 1;};
    class life_fnc_vehicleLights {allowedTargets=CLIENT: jip=1;};
    class life_fnc_copSearch {allowedTargets=CLIENT;};
    class life_fnc_freezePlayer {allowedTargets=CLIENT;};
    class life_fnc_gangCreated {allowedTargets=CLIENT;};
    class life_fnc_gangDisbanded {allowedTargets=CLIENT;};
    class life_fnc_gangInvite {allowedTargets=CLIENT;};
    class life_fnc_garageRefund {allowedTargets=CLIENT;};
    class life_fnc_giveDiff {allowedTargets=CLIENT;};
    class life_fnc_hideObj {allowedTargets=CLIENT;};
    class life_fnc_impoundMenu {allowedTargets=CLIENT;};
    class life_fnc_jail {allowedTargets=CLIENT;};
    class life_fnc_jailMe {allowedTargets=CLIENT;};
    class life_fnc_knockedOut {allowedTargets=CLIENT;};
    class life_fnc_licenseCheck {allowedTargets=CLIENT;};
    class life_fnc_licensesRead {allowedTargets=CLIENT;};
    class life_fnc_lightHouse {allowedTargets=CLIENT;};
    class life_fnc_medicRequest {allowedTargets=CLIENT;};
    class life_fnc_moveIn {allowedTargets=CLIENT;};
    class life_fnc_pickupItem {allowedTargets=CLIENT;};
    class life_fnc_pickupMoney {allowedTargets=CLIENT;};
    class life_fnc_receiveItem {allowedTargets=CLIENT;};
    class life_fnc_receiveMoney {allowedTargets=CLIENT;};
    class life_fnc_removeLicenses {allowedTargets=CLIENT;};
    class life_fnc_restrain {allowedTargets=CLIENT;};
    class life_fnc_revived {allowedTargets=CLIENT;};
    class life_fnc_robPerson {allowedTargets=CLIENT;};
    class life_fnc_robReceive {allowedTargets=CLIENT;};
    class life_fnc_searchClient {allowedTargets=CLIENT;};
    class life_fnc_seizeClient {allowedTargets=CLIENT;};
    class life_fnc_soundDevice {allowedTargets=CLIENT;};
    class life_fnc_spikeStripEffect {allowedTargets=CLIENT;};
    class life_fnc_tazeSound {allowedTargets=CLIENT;};
    class life_fnc_ticketPaid {allowedTargets=CLIENT;};
    class life_fnc_ticketPrompt {allowedTargets=CLIENT;};
    class life_fnc_vehicleAnimate {allowedTargets=CLIENT;};
    class life_fnc_wantedList {allowedTargets=CLIENT;};
    class life_fnc_wireTransfer {allowedTargets=CLIENT;};
    class life_fnc_gangBankResponse {allowedTargets=CLIENT;};
    class life_fnc_chopShopSold {allowedTargets=CLIENT;};
    class SOCK_fnc_dataQuery {allowedTargets=CLIENT;};
    class SOCK_fnc_insertPlayerInfo {allowedTargets=CLIENT;};
    class SOCK_fnc_requestReceived {allowedTargets=CLIENT;};
    class SOCK_fnc_updateRequest {allowedTargets=CLIENT;};
    class life_fnc_clientGangKick {allowedTargets=CLIENT;};
    class life_fnc_clientGangLeader {allowedTargets=CLIENT; jip = 1;};
    class life_fnc_clientGangLeft {allowedTargets=CLIENT;};
    class life_fnc_clientGetKey {allowedTargets=CLIENT;};
    class life_fnc_clientMessage {allowedTargets=CLIENT;};
    class life_util_fnc_playerQuery {allowedTargets=CLIENT;};

    /* Server only functions */
    class DB_fnc_insertRequest {allowedTargets=SERVER;};
    class DB_fnc_queryRequest {allowedTargets=SERVER;};
    class DB_fnc_updatePartial {allowedTargets=SERVER;};
    class DB_fnc_updateRequest {allowedTargets=SERVER;};
    class life_fnc_jailSys {allowedTargets=SERVER;};
    class life_fnc_wantedAdd {allowedTargets=SERVER;};
    class life_fnc_wantedBounty {allowedTargets=SERVER;};
    class life_fnc_wantedCrimes {allowedTargets=SERVER;};
    class life_fnc_wantedFetch {allowedTargets=SERVER;};
    class life_fnc_wantedProfUpdate {allowedTargets=SERVER;};
    class life_fnc_wantedRemove {allowedTargets=SERVER;};
    class SPY_fnc_cookieJar {allowedTargets=SERVER;};
    class SPY_fnc_observe {allowedTargets=SERVER;};
    class TON_fnc_addContainer {allowedTargets=SERVER;};
    class TON_fnc_addHouse {allowedTargets=SERVER;};
    class TON_fnc_chopShopSell {allowedTargets=SERVER;};
    class TON_fnc_cleanupRequest {allowedTargets=SERVER;};
    class TON_fnc_deleteDBContainer {allowedTargets=SERVER;};
    class TON_fnc_getID {allowedTargets=SERVER;};
    class TON_fnc_getVehicles {allowedTargets=SERVER;};
    class TON_fnc_insertGang {allowedTargets=SERVER;};
    class TON_fnc_keyManagement {allowedTargets=SERVER;};
    class TON_fnc_manageSC {allowedTargets=SERVER;};
    class TON_fnc_pickupAction {allowedTargets=SERVER;};
    class TON_fnc_removeGang {allowedTargets=SERVER;};
    class TON_fnc_sellHouse {allowedTargets=SERVER;};
    class TON_fnc_sellHouseContainer {allowedTargets=SERVER;};
    class TON_fnc_spawnVehicle {allowedTargets=SERVER;};
    class TON_fnc_spikeStrip {allowedTargets=SERVER;};
    class TON_fnc_updateGang {allowedTargets=SERVER;};
    class TON_fnc_updateHouseContainers {allowedTargets=SERVER;};
    class TON_fnc_updateHouseTrunk {allowedTargets=SERVER;};
    class TON_fnc_vehicleCreate {allowedTargets=SERVER;};
    class TON_fnc_vehicleDelete {allowedTargets=SERVER;};
    class TON_fnc_vehicleStore {allowedTargets=SERVER;};
    class TON_fnc_vehicleUpdate {allowedTargets=SERVER;};
    class TON_fnc_handleBlastingCharge {allowedTargets=SERVER;};
    class TON_fnc_houseGarage {allowedTargets=SERVER;};

    /* HeadlessClient only functions */
    class HC_fnc_addContainer {allowedTargets=HC;};
    class HC_fnc_addHouse {allowedTargets=HC;};
    class HC_fnc_chopShopSell {allowedTargets=HC;};
    class HC_fnc_deleteDBContainer {allowedTargets=HC;};
    class HC_fnc_getVehicles {allowedTargets=HC;};
    class HC_fnc_houseGarage {allowedTargets=HC;};
    class HC_fnc_insertGang {allowedTargets=HC;};
    class HC_fnc_insertRequest {allowedTargets=HC;};
    class HC_fnc_insertVehicle {allowedTargets=HC;};
    class HC_fnc_jailSys {allowedTargets=HC;};
    class HC_fnc_keyManagement {allowedTargets=HC;};
    class HC_fnc_queryRequest {allowedTargets=HC;};
    class HC_fnc_removeGang {allowedTargets=HC;};
    class HC_fnc_sellHouse {allowedTargets=HC;};
    class HC_fnc_sellHouseContainer {allowedTargets=HC;};
    class HC_fnc_spawnVehicle {allowedTargets=HC;};
    class HC_fnc_spikeStrip {allowedTargets=HC;};
    class HC_fnc_updateGang {allowedTargets=HC;};
    class HC_fnc_updateHouseContainers {allowedTargets=HC;};
    class HC_fnc_updateHouseTrunk {allowedTargets=HC;};
    class HC_fnc_updatePartial {allowedTargets=HC;};
    class HC_fnc_updateRequest {allowedTargets=HC;};
    class HC_fnc_vehicleCreate {allowedTargets=HC;};
    class HC_fnc_vehicleDelete {allowedTargets=HC;};
    class HC_fnc_vehicleStore {allowedTargets=HC;};
    class HC_fnc_vehicleUpdate {allowedTargets=HC;};
    class HC_fnc_wantedAdd {allowedTargets=HC;};
    class HC_fnc_wantedBounty {allowedTargets=HC;};
    class HC_fnc_wantedCrimes {allowedTargets=HC;};
    class HC_fnc_wantedFetch {allowedTargets=HC;};
    class HC_fnc_wantedProfUpdate {allowedTargets=HC;};
    class HC_fnc_wantedRemove {allowedTargets=HC;};

    /* Functions for everyone */
    class BIS_fnc_effectKilledAirDestruction {allowedTargets=ANYONE;};
    class BIS_fnc_effectKilledSecondaries {allowedTargets=ANYONE;};
    class life_fnc_animSync {allowedTargets=ANYONE;};
    class life_fnc_broadcast {allowedTargets=ANYONE;};
    class life_fnc_colorVehicle {allowedTargets=ANYONE;};
    class life_fnc_corpse {allowedTargets=ANYONE;};
    class life_fnc_demoChargeTimer {allowedTargets=ANYONE;};
    class life_fnc_flashbang {allowedTargets=ANYONE;};
    class life_fnc_jumpFnc {allowedTargets=ANYONE;};
    class life_fnc_lockVehicle {allowedTargets=ANYONE;};
    class life_fnc_pulloutVeh {allowedTargets=ANYONE;};
    class life_fnc_say3D {allowedTargets=ANYONE;};
    class life_fnc_setFuel {allowedTargets=ANYONE;};
    class life_fnc_simDisable {allowedTargets=ANYONE;};
    class life_fnc_initACE {allowedTargets=ANYONE;}; // ACE API
    class life_fnc_openGarage {allowedTargets=ANYONE;}; // ACE Garage Dialog

    };

    class Commands {
        mode = 1;
        jip = 1;

    /* Commands */
    class execVM {allowedTargets=SERVER;};
    class enableSimulationGlobal {allowedTargets=SERVER;};
    class setObjectTexture {allowedTargets=ANYONE;};
    class setObjectTextureGlobal {allowedTargets=ANYONE;};
    class setObjectMaterial {allowedTargets=ANYONE;};
    class setObjectMaterialGlobal {allowedTargets=ANYONE;};
    class playMove {allowedTargets=ANYONE;}; // KKA A3 Animationen
    class switchMove {allowedTargets=ANYONE;}; // KKA A3 Animationen
    class addHandgunItem {allowedTargets=ANYONE;};
    class addMagazine {allowedTargets=ANYONE;};
    class addPrimaryWeaponItem {allowedTargets=ANYONE;};
    class addWeapon {allowedTargets=ANYONE;};
    class setFuel {allowedTargets=ANYONE;};

    };
};
