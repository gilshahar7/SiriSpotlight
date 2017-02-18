ARCHS = armv7 arm64
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SpotlightSiri10
SpotlightSiri10_FILES = Tweak.xm
SpotlightSiri10_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
