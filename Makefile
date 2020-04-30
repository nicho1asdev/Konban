
include $(THEOS)/makefiles/common.mk

SUBPROJECTS += KonbanSpringboard KonbanClient Prefs

THEOS_DEVICE_IP = 192.168.1.71
THEOS_DEVICE_PORT = 22

include $(THEOS_MAKE_PATH)/aggregate.mk
