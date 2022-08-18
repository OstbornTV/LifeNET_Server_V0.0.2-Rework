# CXP SCRIPTS PACKAGES' FRAMEWORK MANUAL

***WARNING**: if you already own any of our products, you can jump to the 'PRODUCT INSTALLATION MANUAL' provided in the product's download page*

1. Copy the folder **cxp\\** to your mission folder (a.k.a ***missionName.Map***)
2. Open your **missionName.Map\\description.ext** file and add the following code like the images suggests:
    - Below your ``` #include "config\Config_Master.hpp" ``` line:
    ```sqf
    #include "cxp\cxp_cfgs.cpp"
    #include "cxp\cxp_dialogs.cpp"
    ```
    - Inside your ``` class RscTitles { ``` class:
    ```sqf
    #include "cxp\cxp_titles.cpp"
    ```

    **Example (lines: 10 and 11, 28):**

    <img src="../images/cxp/image1.png" style="width:3.79167in;height:4.96875in" />

    - Inside your ``` class CfgFunctions { ``` class:
    ```sqf
    #include "cxp\cxp_functions.cpp"
    ```

    **Example (line 31):**

    <img src="../images/cxp/image2.png" style="width:4.13542in;height:2.97917in" />

    - Inside your ``` class CfgNotifications { ``` class:
    ```sqf
    #include "cxp\cxp_notifications.cpp"
    ```

    **Example (line 116):**

    <img src="../images/cxp/image3.png" style="width:6.30208in;height:2.01042in" />

3. Open your **missionName.Map\\CfgRemoteExec.hpp** file and add:

    - Below your ``` jip = 0; ``` declaration:
    ```sqf
    #include "cxp\cxp_remoteExecs.cpp"
    ```

    **Example (line 19):**

    <img src="../images/cxp/image4.png" style="width:4.10417in;height:2.5625in" />
