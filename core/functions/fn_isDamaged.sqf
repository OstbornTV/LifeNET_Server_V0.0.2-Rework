/*
*        File: fn_isDamaged.sqf
*        Author: BoGuu
*
*        Description:
*        Returns true if the target is damaged, else returns false.
*/
params [
    ["_target",objNull,[objNull]]
];

// Holt den höchsten Schadenswert für den dritten Trefferpunkt des Ziels
private _damage = selectMax (getAllHitPointsDamage _target select 2);

// Gibt true zurück, wenn der Schaden größer als 0.01 ist, andernfalls false
(_damage > 0.01);
