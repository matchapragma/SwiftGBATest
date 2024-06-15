#---------------------------------------------------------------------------------------------------------------------
# Make Swift Object
#---------------------------------------------------------------------------------------------------------------------
BUILD       :=  build
SWIFTTARGET := armv4t-none-none-eabi

SWFTSOURCE := swift-src

SWIFT_EXEC := $(shell xcrun -f swiftc)
SWIFT_FLAGS := -target $(SWIFTTARGET) -Xcc -std=c++20 -Xcc -fshort-enums -Xfrontend -disable-reflection-metadata -Xfrontend -function-sections -enable-experimental-feature Embedded -no-allocations -wmo -parse-as-library -cxx-interoperability-mode=default -I $(SWFTSOURCE)/include

# -import-bridging-header $(SWFTSOURCE)/BridgingHeader.hpp

$(BUILD)/swiftSources.o: $(SWFTSOURCE)/smain.swift
	# Build Swift sources
	$(SWIFT_EXEC) $(SWIFT_FLAGS) -c $^ -o $@