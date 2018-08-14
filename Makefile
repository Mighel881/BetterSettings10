include $(THEOS)/makefiles/common.mk

TWEAK_NAME = rewriteSettings
rewriteSettings_FILES = Tweak.xm UIImage+ScaledImage.m BSProvider.m
rewriteSettings_CFLAGS +=  -fobjc-arc
rewriteSettings_LDFLAGS += -lCSColorPicker -lCSPreferencesProvider

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
SUBPROJECTS += bettersettings
include $(THEOS_MAKE_PATH)/aggregate.mk
