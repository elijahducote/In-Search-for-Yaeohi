// Godot SDK
#include <Godot/godot.hpp>
#include <Godot/variant/utility_functions.hpp>
#include <Godot/classes/v_box_container.hpp>
#include <Godot/variant/variant.hpp>
#include <cmath>

// Jenova SDK
#include <JenovaSDK.h>

// Namespaces
using namespace godot;
using namespace jenova::sdk;

// Start Jenvoa Script
JENOVA_SCRIPT_BEGIN

VBoxContainer* me;

void OnReady(Caller* instance)
{
	me = (VBoxContainer*)instance->self;
}

void OnProcess(double delta)
{
	// sin((45/pi) * delta)
	me->set_position(Vector2(0,300));
	UtilityFunctions::print(delta);
}

// End Jenova Script
JENOVA_SCRIPT_END
