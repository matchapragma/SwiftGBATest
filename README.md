# Swift Embedded on GBA

It's WWDC season! Swift Embedded was one of the new things shown this week that excited me the most, so I wanted to try and get it running on a console I love programming on: the GameBoy Advance.

I've left the Issues tab open in case I made a pretty big error and I haven't noticed, or someone knows a solution to one of the issues I encountered (they were pretty funky issues).

This is a very meaty README, please use this handy dandy Table of Contents™ so you don't get lost:

- [The Project](#the-project)
	- [What does the code do?](#what-does-the-code-do)
	- [Important Files & Directories](#important-files-directories)
	- [Compilation](#compilation)
- [Conclusion](#conclusion)
- [Further Reading](#further-reading)

## The Project

### What does the code do?
The code creates two sprites in the centre of the screen. It then interacts with Swift to move the sprites.

For the first sprite, a Swift method is called from C++ and the return value is used to move the sprite.

For the second sprite, a Swift method is called from C++. This method takes an Int Pointer (`int*`) and reassign's the integer it is pointing to.

### Important Files & Directories

#### swift-src
This folder contains Swift source code. I created a sub-directory for the Bridging Header and Module Map files but they ended up going unused.

Keeping the Swift side of the project contained in its own directory makes things more organised.
> [!IMPORTANT]
> Even though the Swift source files are in their own directory, they cannot share names with your C++ source files (e.g you can't have "main.swift" and "main.cpp")

#### swift.mak
This Makefile generates an .o file from our Swift source code.

#### butano_swift.mak
This is a modified version of Butano's main Makefile; it links the .o file generated from our Swift source code to the rest of our code.
> [!NOTE]
> I recommend placing this file in the same directory as the default Butano Makefile so that you don't need to make many adjustments to your project's Makefile. Do not change the default Makefile!!

#### buildrun.sh
This shell script will clear the terminal, run the swift.mak Makefile, then run the project's Makefile. Its a pretty inelegant script as it doesn't check to see if the previous steps failed or not.

### Compilation
The project is compiled by following these steps in order:
- Run `make -f swift.mak` to compile the Swift code
- Run `make` which uses the default Makefile to compile the rest of the code and link it together

A quirk I noticed when doing this is that if I want to add new functions or make big changes to my Swift source code, I will need to delete the Build directory or I'll end up with "overlapping sections". My educated guess as to why this happens is because the Swift compiler doesn't know about the rest of the codebase, and therefore it tries to map things into places that are taken up by other methods or whatever...

## Conclusion
Below I discuss the purpose of this experiment and how I feel it may be useful. Additionally, I've detailed some particular sore spots I encountered.

Swift Embedded is very exciting. C and C++ are powerful languages but they're pretty demanding of the programmer, I personally describe this as respecting the computer as opposed to languages like C# where a lot of the "respecting" is done under the hood. Therefore it isn't as accessible as languages like C# or Swift are; even though I've managed to get a little bit cozy with C++ it was still a massive hurdle for me to overcome.

Swift Embedded is a subset of Swift, meaning that its code is also valid Swift code; and you can write Swift Embedded code without having to think too much about the differences.

This opens programming on Embedded Systems, and well... anywhere we can get Swift Embedded to work on, up to many more programmers who may have felt intimidated to write code for these platforms otherwise.

Thank you to GValiente and to all Butano contributors for making the Butano library. Thank you to all the contributors of the Swift project for making the language and for bringing it to so many places. And thank yee too for reading ♥︎

### Issue 1 - Interacting with C++ Classes/Structs in Swift
Originally, I wanted Swift to call methods on a C++ class to change its int variables. However, I encountered a very weird issue when trying this:
```
(...) swiftSources.0:(.ARM.extab.text.$s12swiftSources11anotherFunc3clsySpySo9SomeClassVG_tF+0X0): undefined reference to '_swift_exceptionPersonality'
```
When searching for what '_swift_exceptionPersonality' could be: I got only one result which pointed to a file in Swift's source code. The file was all to do with Reflection, and a key thing about Swift Embedded is that it doesn't support Reflection.

I think by passing a pointer to the class as a parameter, some Reflection trickery happened under the hood, and of course the compiler wasn't too happy about that.

To workaround this, we can simply pass a pointer to a member of the class to the method, instead of the whole class.

### Issue 2 - Compiling
The way I set up my project means I have to compile the Swift-side of the codebase before I compile the rest. As mentioned previously, this lead to me annoying the linker.

To workaround this, I delete the Build directory of the project. This solves the issue but has the added downside of having to recompile a whole load of Butano's headers again. For this to have practical applications, a solution to this needs to be figured out.

### Issue 3 - SCIENCE!!
Swift Embedded is experimental, which of course means that documentation and examples are sparse. To figure this out I did a lot of bashing pebbles and sticks together until I made fire.

That's one of the joys of this sort of thing; figuring things out for yourself... it makes you feel **very** smart. That also means you'll be encountering some very exotic bugs and errors; this really isn't for the feint of CPU- I mean heart. 

## Further Reading

### Butano

Butano is a modern, high-level C++ library for making GBA homebrew games. It is licensed under the [Zlib license](https://github.com/GValiente/butano/blob/master/LICENSE).

https://github.com/GValiente/butano

### WWDC Sessions

See below relevant WWDC sessions which go into more detail about Swift Embedded, and the Swift programming language as a whole.

#### WWDC24: A Swift Tour: Explore Swift’s features and design | Apple
If you've never written or seen Swift code, please watch this session! It explains everything you need to know and the design philosophies of the Swift language.<br>
https://www.youtube.com/watch?v=boiLzazJ9j4

#### WWDC24: Go small with Embedded Swift | Apple
This session introduces Swift Embedded, demonstrated by creating a HomeKit accessory using an ESP32C6 development board.<br>
https://www.youtube.com/watch?v=LqxbsADqDI4