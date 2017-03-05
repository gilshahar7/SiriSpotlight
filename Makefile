ARCHS = armv7 arm64
DEBUG = 0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SiriSpotlight
SiriSpotlight_FILES = Tweak.xm
SiriSpotlight_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
