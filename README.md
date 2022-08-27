## Enemy Scale Standoff 2 0.19.4 iOS

<b> Example: </b>
```
#include "Vector3.h"

int (*PlayerController_get_team)(void*);
bool (*PlayerController_get_isLocal)(void*);
void (*Transform_set_localScale)(void*, Vector3);
void *(*Component_get_transform)(void*);

void *me = NULL;
void *enemy = NULL;

void (*old_Player_Update)(void *player); 
void Player_Update(void *player) { 
	if(PlayerController_get_isLocal(player)) {
		me = player;
	}

	if(me != NULL) {
		if(PlayerController_get_team(me) != PlayerController_get_team(player)) {
			enemy = player;
		}

		if([switches isSwitchOn:@"Enemy Scale"]) {
			float scale = [[switches getValueFromSwitch:@"Enemy Scale"] floatValue];
			Transform_set_localScale(Component_get_transform(enemy), Vector3(scale, scale, scale));
		} else {
			Transform_set_localScale(Component_get_transform(enemy), Vector3(1, 1, 1));
		}
	} 
    old_Player_Update(player); 
} 
 
void setup() {
 
PlayerController_get_team = (int (*)(void *))getRealOffset(0x1A25E24);
PlayerController_get_isLocal = (bool (*)(void *))getRealOffset(0x1A26264);
Transform_set_localScale = (void (*)(void*, Vector3))getRealOffset(0x2701B98);
Component_get_transform = (void* (*)(void*))getRealOffset(0x26D3288);

HOOK(0x1A25490, Player_Update, old_Player_Update);

[switches addSwitch:@"Enemy Scale" description:@"Change enemy scale"];
[switches addSliderSwitch:@"Enemy Scale" description:@"Change enemy scale" minimumValue:1 maximumValue:10 sliderColor:UIColorFromHex(0xBD0000)];

}

```