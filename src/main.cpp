#include "bn_core.h"

#include "bn_sprite_ptr.h"
#include "bn_sprite_items_dummy.h"

#include "someclass.hpp"

extern "C" int someFunc();
extern "C" int anotherFunc(int*);

int main()
{
    bn::core::init();

    bn::sprite_ptr dummy = bn::sprite_items::dummy.create_sprite(0, 0);
    bn::sprite_ptr dummy2 = bn::sprite_items::dummy.create_sprite(0, 0);

    SomeClass cls;

    dummy.set_position(someFunc(), someFunc());
    anotherFunc(&cls.posX);
    anotherFunc(&cls.posY);

    dummy2.set_position(cls.posX, cls.posY);

    while(true)
    {
        bn::core::update();
    }
}
