int (*get_team)(void*);
bool (*get_isLocal)(void*);
void (*set_localScale)(void*, Vector3);
void *(*get_transform)(void*);

void *me = NULL;
void *enemy = NULL;

void (*old_Player_Update)(void *player); 
void Player_Update(void *player) { 
	if(get_isLocal(player)) {
		me = player;
	}

	if(me != NULL) {
		if(get_team(me) != get_team(player)) {
			enemy = player;
		}

		if([switches isSwitchOn:@"Enemy Scale"]) {
			float scale = [[switches getValueFromSwitch:@"Enemy Scale"] floatValue];
			set_localScale(get_transform(enemy), Vector3(scale, scale, scale));
		} else {
			set_localScale(get_transform(enemy), Vector3(1, 1, 1));
		}
	} 
    old_Player_Update(player); 
} 
 
void setup() {
 
get_team = (int (*)(void *))getRealOffset(0x1A25E24);
get_isLocal = (bool (*)(void *))getRealOffset(0x1A26264);
set_localScale = (void (*)(void*, Vector3))getRealOffset(0x2701B98);
get_transform = (void* (*)(void*))getRealOffset(0x26D3288);

HOOK(0x1A25490, Player_Update, old_Player_Update);

[switches addSwitch:@"Enemy Scale" description:@"Change enemy scale"];
[switches addSliderSwitch:@"Enemy Scale" description:@"Change enemy scale" minimumValue:1 maximumValue:10 sliderColor:UIColorFromHex(0xBD0000)];

}