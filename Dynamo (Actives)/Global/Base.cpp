#include <Godot/godot.hpp>
#include <Godot/classes/scene_tree.hpp>
#include <Godot/classes/window.hpp>
#include <Godot/classes/viewport.hpp>
#include <Godot/classes/node.hpp>
#include <Godot/variant/utility_functions.hpp>

#include <JenovaSDK.h>

using namespace godot;
using namespace jenova::sdk;

constexpr const char* grafMID = "graf";

JENOVA_SCRIPT_BEGIN

SceneTree* graf = nullptr;

void OnReady(Caller* instance)
{		
	//auto me = (Node*)instance->self;
	//graf = me->get_tree();
	//pane = graf->get_root();
	//root = graf->get_current_scene();
	//area = root->get_viewport();
	//span = area->get_visible_rect().size;
	//size = span;
	//UtilityFunctions::print((int)currentScene);
	//UtilityFunctions::print(*currentScene);
}

void OnAwake(Caller* instance)
{
	auto me = (Node*)instance->self;
	graf = GlobalPointer<SceneTree>(grafMID);
	graf = me->get_tree();
	
	SetGlobalPointer(grafMID, graf);
	//DeleteGlobalPointer(grafMID);
	//FreeGlobalMemory(GlobalGet(grafMID));
	UtilityFunctions::print(graf);
	//FreeGlobalMemory(grafMID);
	//graf->call_deferred("free");
	
}

void OnDestroy()
{
	if (graf)
	{
		DeleteGlobalPointer(grafMID);
	}
}

JENOVA_SCRIPT_END
