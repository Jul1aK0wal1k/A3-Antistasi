/*
    Author: [Hazey]
    Description:
		Group Patrol Area

    Arguments:
        <Group> Group you want to run a Patrol Area
        <Number> Minimum Radius from Center to Patrol
        <Number> Maximum Radius from Center to Patrol

    Return Value:
    	N/A

    Scope: Any
    Environment: Any
    Public: No

    Example: 
		[_group] call A3A_fnc_patrolArea;

    License: MIT License
*/
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_group", ["_minimumRadius", 50], ["_patrolRadius", 100 + random 150], ["_objectDistance", 0], ["_waterMode", 0], ["_maxGradient", -1], ["_shoreMode", 0]];

// Get home position of the unit.
private _groupHomePosition = _group getVariable "PATCOM_Patrol_Home_Position";

// Add a default patrol radius if we don't have one already specified.
if (_group getVariable ["PATCOM_Patrol_Radius", 0] == 0) then {
	_group setVariable ["PATCOM_Patrol_Radius", _patrolRadius];
};

// If no patrol radius is specified in the param, use default patrol radius for the unit.
if (_patrolRadius == 0) then {
	_patrolRadius = _group getVariable "PATCOM_Patrol_Radius";
};

if ((side leader _group) == civilian) then {
    [_group, "CARELESS", "NORMAL", "LINE", "BLUE", "AUTO"] call A3A_fnc_patrolSetCombatModes;
} else {
    [_group, "SAFE", "FULL", "COLUMN", "YELLOW", "AUTO"] call A3A_fnc_patrolSetCombatModes;
};

// Check for current waypoints and make sure they are type MOVE for patrol
if (currentWaypoint _group == count waypoints _group || waypointType [_group, currentWaypoint _group] != "MOVE") then {
    // | Center Position | Min Radius | Max Radius | Min Object Distance | Water Mode | Max Gradient | ShoreMode |
	private _nextWaypointPos = [_groupHomePosition, _minimumRadius, _patrolRadius, _objectDistance, _waterMode, _maxGradient, _shoreMode] call A3A_fnc_getSafeSpawnPos;
	[_group, "MOVE", "PATCOM_PATROL_AREA", _nextWaypointPos, -1, 50] call A3A_fnc_patrolCreateWaypoint;
};