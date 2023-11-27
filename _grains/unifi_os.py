import salt.modules.cmdmod
import salt.utils.path

__virtualname__ = "unifi_os"


def __virtual__():
    if salt.utils.path.which("ubnt-device-info"):
        return __virtualname__
    return False, "Does not seem to be Unifi OS"


def uos_info():
    ret = {
        "uos_firmware": tuple(int(x) for x in salt.modules.cmdmod.run("ubnt-device-info firmware").split(".")),
        "uos_hardware": salt.modules.cmdmod.run("ubnt-device-info model_short"),
    }
    ret["uos_firmware_major"] = ret["uos_firmware"][0]
    return ret
