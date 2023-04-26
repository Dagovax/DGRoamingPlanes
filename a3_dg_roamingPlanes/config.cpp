class CfgPatches {
	class a3_dg_roamingPlanes {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
	};
};
class CfgFunctions {
	class DGRoamingPlanes {
		tag = "DGRoamingPlanes";
		class Main {
			file = "\x\addons\a3_dg_roamingPlanes\init";
			class init {
				postInit = 1;
			};
		};
	};
};

