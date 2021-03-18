
include $(THEOS)/makefiles/common.mk

SUBPROJECTS += KonbanSpringboard KonbanClient Prefs

THEOS_DEVICE_IP = nicholas-iphone-xr.local
THEOS_DEVICE_PORT = 22

include $(THEOS_MAKE_PATH)/aggregate.mk
