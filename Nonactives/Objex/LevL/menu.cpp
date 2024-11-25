#include <Godot/godot.hpp>
#include <Godot/classes/scene_tree.hpp>
#include <Godot/variant/utility_functions.hpp>

#include <JenovaSDK.h>

using namespace godot;
using namespace jenova::sdk;

JENOVA_SCRIPT_BEGIN

void OnAwake(Caller* instance)
{
	UtilityFunctions::print((SceneTree*)GetGlobalPointer("graf"));
	//UtilityFunctions::print(*(String*)GetGlobalPointer("graf"));
}

JENOVA_SCRIPT_END
