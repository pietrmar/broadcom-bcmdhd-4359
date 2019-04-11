# bcmdhd

MODULE_NAME := bcmdhd
CONFIG_BCMDHD ?= m

#CONFIG_BCMDHD_SDIO := y
#CONFIG_BCMDHD_PCIE := y
#CONFIG_BCMDHD_USB := y

#CONFIG_BCMDHD_OOB := y
#CONFIG_BCMDHD_CUSB := y
#CONFIG_BCMDHD_NO_POWER_OFF := y
CONFIG_BCMDHD_PROPTXSTATUS := y
#CONFIG_DHD_USE_STATIC_BUF := y
#CONFIG_BCMDHD_STATIC_BUF_IN_DHD := y
#CONFIG_BCMDHD_ANDROID_VERSION := 11
CONFIG_BCMDHD_AUTO_SELECT := y
CONFIG_BCMDHD_DEBUG := y
#CONFIG_BCMDHD_TIMESTAMP := y
#CONFIG_BCMDHD_WAPI := y
#CONFIG_BCMDHD_RANDOM_MAC := y
#CONFIG_BCMDHD_REQUEST_FW := y
#CONFIG_BCMDHD_MULTIPLE_DRIVER := y
#CONFIG_BCMDHD_DWDS := y

CONFIG_MACH_PLATFORM := y
#CONFIG_BCMDHD_DTS := y

DHDCFLAGS = -Wall -Wstrict-prototypes -Wno-date-time                      \
	-Dlinux -DLINUX -DBCMDRIVER                                           \
	-DBCMDONGLEHOST -DBCMDMA32 -DBCMFILEIMAGE                             \
	-DDHDTHREAD -DDHD_DEBUG -DSHOW_EVENTS -DGET_OTP_MAC_ENABLE            \
	-DWIFI_ACT_FRAME -DARP_OFFLOAD_SUPPORT -DSUPPORT_PM2_ONLY             \
	-DKEEP_ALIVE -DPKT_FILTER_SUPPORT -DDHDTCPACK_SUPPRESS                \
	-DDHD_DONOT_FORWARD_BCMEVENT_AS_NETWORK_PKT -DOEM_ANDROID             \
	-DMULTIPLE_SUPPLICANT -DTSQ_MULTIPLIER -DMFP -DDHD_8021X_DUMP         \
	-DPOWERUP_MAX_RETRY=0 -DIFACE_HANG_FORCE_DEV_CLOSE -DWAIT_DEQUEUE     \
	-DUSE_NEW_RSPEC_DEFS                                                  \
	-DWL_EXT_IAPSTA -DWL_ESCAN -DCCODE_LIST -DSUSPEND_EVENT               \
	-DEAPOL_RESEND -DEAPOL_DYNAMATIC_RESEND                               \
	-DENABLE_INSMOD_NO_FW_LOAD

DHDOFILES = aiutils.o siutils.o sbutils.o bcmutils.o bcmwifi_channels.o   \
	dhd_linux.o dhd_linux_platdev.o dhd_linux_sched.o dhd_pno.o           \
	dhd_common.o dhd_ip.o dhd_linux_wq.o dhd_custom_gpio.o                \
	bcmevent.o hndpmu.o linux_osl.o wldev_common.o wl_android.o           \
	dhd_debug_linux.o dhd_debug.o dhd_mschdbg.o dhd_dbg_ring.o            \
	hnd_pktq.o hnd_pktpool.o bcmxtlv.o linux_pkt.o bcmstdlib_s.o frag.o   \
	dhd_linux_exportfs.o dhd_linux_pktdump.o dhd_mschdbg.o                \
	dhd_config.o dhd_ccode.o wl_event.o wl_android_ext.o                  \
	wl_iapsta.o wl_escan.o wl_timer.o

ifneq ($(CONFIG_WIRELESS_EXT),)
	DHDOFILES += wl_iw.o
	DHDCFLAGS += -DSOFTAP -DWL_WIRELESS_EXT -DUSE_IW
endif
ifneq ($(CONFIG_CFG80211),)
	DHDOFILES += wl_cfg80211.o wl_cfgscan.o wl_cfgp2p.o
	DHDOFILES += wl_linux_mon.o wl_cfg_btcoex.o wl_cfgvendor.o
	DHDOFILES += dhd_cfg80211.o wl_cfgvif.o
	DHDCFLAGS += -DWL_CFG80211 -DWLP2P -DWL_CFG80211_STA_EVENT
	DHDCFLAGS += -DWL_IFACE_COMB_NUM_CHANNELS
	DHDCFLAGS += -DCUSTOM_PNO_EVENT_LOCK_xTIME=10
	DHDCFLAGS += -DWL_SUPPORT_AUTO_CHANNEL
	DHDCFLAGS += -DWL_SUPPORT_BACKPORTED_KPATCHES
	DHDCFLAGS += -DESCAN_RESULT_PATCH -DESCAN_BUF_OVERFLOW_MGMT
	DHDCFLAGS += -DVSDB -DWL_CFG80211_VSDB_PRIORITIZE_SCAN_REQUEST
	DHDCFLAGS += -DMIRACAST_AMPDU_SIZE=8
	DHDCFLAGS += -DWL_VIRTUAL_APSTA
	DHDCFLAGS += -DPNO_SUPPORT -DEXPLICIT_DISCIF_CLEANUP
	DHDCFLAGS += -DDHD_USE_SCAN_WAKELOCK
	DHDCFLAGS += -DSPECIFIC_MAC_GEN_SCHEME
	DHDCFLAGS += -DWL_IFACE_MGMT
	DHDCFLAGS += -DWLFBT -DWL_GCMP_SUPPORT
	DHDCFLAGS += -DWL_EXT_RECONNECT
	DHDCFLAGS += -DDHD_LOSSLESS_ROAMING
	DHDCFLAGS += -DGTK_OFFLOAD_SUPPORT
	DHDCFLAGS += -DRESTART_AP_WAR
#	DHDCFLAGS += -DWL_STATIC_IF
	DHDCFLAGS += -DWL_CLIENT_SAE -DWL_OWE
endif

#BCMDHD_SDIO
ifneq ($(CONFIG_BCMDHD_SDIO),)
BUS_TYPE := "sdio"
DHDCFLAGS += -DBCMSDIO -DMMC_SDIO_ABORT -DMMC_SW_RESET -DBCMLXSDMMC       \
	-DUSE_SDIOFIFO_IOVAR -DSDTEST                                         \
	-DBDC -DDHD_USE_IDLECOUNT -DCUSTOM_SDIO_F2_BLKSIZE=256                \
	-DBCMSDIOH_TXGLOM -DBCMSDIOH_TXGLOM_EXT -DRXFRAME_THREAD              \
	-DDHDENABLE_TAILPAD -DSUPPORT_P2P_GO_PS                               \
	-DBCMSDIO_RXLIM_POST -DBCMSDIO_TXSEQ_SYNC -DCONSOLE_DPC               \
	-DBCMSDIO_INTSTATUS_WAR
ifeq ($(CONFIG_BCMDHD_OOB),y)
	DHDCFLAGS += -DOOB_INTR_ONLY -DCUSTOMER_OOB -DHW_OOB
ifeq ($(CONFIG_BCMDHD_DISABLE_WOWLAN),y)
	DHDCFLAGS += -DDISABLE_WOWLAN
endif
else
	DHDCFLAGS += -DSDIO_ISR_THREAD
endif
DHDOFILES += bcmsdh.o bcmsdh_linux.o bcmsdh_sdmmc.o bcmsdh_sdmmc_linux.o  \
	dhd_sdio.o dhd_cdc.o dhd_wlfc.o
endif

#BCMDHD_PCIE
ifneq ($(CONFIG_BCMDHD_PCIE),)
BUS_TYPE := "pcie"
DHDCFLAGS += -DPCIE_FULL_DONGLE -DBCMPCIE -DCUSTOM_DPC_PRIO_SETTING=-1    \
	-DDONGLE_ENABLE_ISOLATION
DHDCFLAGS += -DDHD_LB -DDHD_LB_RXP -DDHD_LB_STATS -DDHD_LB_TXP
DHDCFLAGS += -DDHD_PKTID_AUDIT_ENABLED
DHDCFLAGS += -DINSMOD_FW_LOAD
DHDCFLAGS += -DCONFIG_HAS_WAKELOCK
#DHDCFLAGS += -DDHD_PCIE_RUNTIMEPM -DMAX_IDLE_COUNT=11 -DCUSTOM_DHD_RUNTIME_MS=100
ifeq ($(CONFIG_BCMDHD_OOB),y)
	DHDCFLAGS += -DCUSTOMER_OOB -DBCMPCIE_OOB_HOST_WAKE -DHW_OOB
endif
ifneq ($(CONFIG_PCI_MSI),)
	DHDCFLAGS += -DDHD_MSI_SUPPORT
endif
DHDOFILES += dhd_pcie.o dhd_pcie_linux.o pcie_core.o dhd_flowring.o       \
	dhd_msgbuf.o dhd_linux_lb.o
endif

#BCMDHD_USB
ifneq ($(CONFIG_BCMDHD_USB),)
BUS_TYPE := "usb"
DHDCFLAGS += -DUSBOS_TX_THREAD -DBCMDBUS -DBCMTRXV2 -DDBUS_USB_LOOPBACK   \
	-DBDC
DHDCFLAGS += -DBCM_REQUEST_FW -DEXTERNAL_FW_PATH
ifneq ($(CONFIG_BCMDHD_CUSB),)
	DHDCFLAGS += -DBCMUSBDEV_COMPOSITE
	CONFIG_BCMDHD_NO_POWER_OFF := y
endif
DHDOFILES += dbus.o dbus_usb.o dbus_usb_linux.o dhd_cdc.o dhd_wlfc.o
endif

ifeq ($(CONFIG_BCMDHD_NO_POWER_OFF),y)
	DHDCFLAGS += -DENABLE_INSMOD_NO_FW_LOAD
	DHDCFLAGS += -DENABLE_INSMOD_NO_POWER_OFF -DNO_POWER_OFF_AFTER_OPEN
endif

ifeq ($(CONFIG_BCMDHD_MULTIPLE_DRIVER),y)
	DHDCFLAGS += -DBCMDHD_MDRIVER
	DHDCFLAGS += -DBUS_TYPE=\"-$(BUS_TYPE)\"
	DHDCFLAGS += -DDHD_LOG_PREFIX=\"[dhd-$(BUS_TYPE)]\"
	MODULE_NAME := dhd$(BUS_TYPE)
else
	DHDCFLAGS += -DBUS_TYPE=\"\"
endif

ifeq ($(CONFIG_BCMDHD_TIMESTAMP),y)
	DHDCFLAGS += -DKERNEL_TIMESTAMP
	DHDCFLAGS += -DSYSTEM_TIMESTAMP
endif

#PROPTXSTATUS
ifeq ($(CONFIG_BCMDHD_PROPTXSTATUS),y)
ifneq ($(CONFIG_BCMDHD_USB),)
	DHDCFLAGS += -DPROP_TXSTATUS
endif
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DPROP_TXSTATUS -DPROPTX_MAXCOUNT
endif
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DPROP_TXSTATUS_VSDB
endif
endif

ifeq ($(CONFIG_64BIT),y)
    DHDCFLAGS := $(filter-out -DBCMDMA32,$(DHDCFLAGS))
    DHDCFLAGS += -DBCMDMA64OSL
endif

# For Android VTS
ifneq ($(CONFIG_BCMDHD_ANDROID_VERSION),)
	DHDCFLAGS += -DANDROID_VERSION=$(CONFIG_BCMDHD_ANDROID_VERSION)
	DHDCFLAGS += -DDHD_NOTIFY_MAC_CHANGED
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DGSCAN_SUPPORT -DRTT_SUPPORT -DLINKSTAT_SUPPORT
	DHDCFLAGS += -DCUSTOM_COUNTRY_CODE -DDHD_GET_VALID_CHANNELS
	DHDCFLAGS += -DDEBUGABILITY -DDBG_PKT_MON
	DHDCFLAGS += -DDHD_LOG_DUMP -DDHD_FW_COREDUMP
	DHDCFLAGS += -DAPF -DNDO_CONFIG_SUPPORT -DRSSI_MONITOR_SUPPORT
	DHDCFLAGS += -DDHD_WAKE_STATUS -DWL_LATENCY_MODE
	DHDOFILES += dhd_rtt.o bcm_app_utils.o
endif
else
	DHDCFLAGS += -DANDROID_VERSION=0
endif

# For Debug
ifeq ($(CONFIG_BCMDHD_DEBUG),y)
	DHDCFLAGS += -DDHD_ARP_DUMP -DDHD_DHCP_DUMP -DDHD_ICMP_DUMP
	DHDCFLAGS += -DDHD_DNS_DUMP -DDHD_TRX_DUMP
	DHDCFLAGS += -DTPUT_MONITOR
#	DHDCFLAGS += -DSCAN_SUPPRESS -DBSSCACHE
	DHDCFLAGS += -DCHECK_DOWNLOAD_FW
	DHDCFLAGS += -DPKT_STATICS
	DHDCFLAGS += -DKSO_DEBUG
#	DHDCFLAGS += -DDHD_PKTDUMP_TOFW
endif

# For Debug2
ifeq ($(CONFIG_BCMDHD_DEBUG2),y)
	DHDCFLAGS += -DDEBUGFS_CFG80211
	DHDCFLAGS += -DSHOW_LOGTRACE -DDHD_LOG_DUMP -DDHD_FW_COREDUMP
	DHDCFLAGS += -DBCMASSERT_LOG -DSI_ERROR_ENFORCE
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DEWP_EDL
	DHDCFLAGS += -DDNGL_EVENT_SUPPORT
	DHDCFLAGS += -DDHD_SSSR_DUMP
endif
endif

# MESH support for kernel 3.10 later
ifeq ($(CONFIG_WL_MESH),y)
	DHDCFLAGS += -DWLMESH
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DWLMESH_CFG80211
endif
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DBCM_HOST_BUF -DDMA_HOST_BUFFER_LEN=0x80000
endif
	DHDCFLAGS += -DDHD_UPDATE_INTF_MAC
	DHDCFLAGS :=$(filter-out -DDHD_FW_COREDUMP,$(DHDCFLAGS))
	DHDCFLAGS :=$(filter-out -DWL_STATIC_IF,$(DHDCFLAGS))
endif

# EasyMesh
ifeq ($(CONFIG_BCMDHD_EASYMESH),y)
	DHDCFLAGS :=$(filter-out -DDHD_FW_COREDUMP,$(DHDCFLAGS))
	DHDCFLAGS :=$(filter-out -DDHD_LOG_DUMP,$(DHDCFLAGS))
	DHDCFLAGS += -DWLEASYMESH
	CONFIG_BCMDHD_DWDS := y
endif

# DWDS
ifeq ($(CONFIG_BCMDHD_DWDS),y)
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DWLDWDS -DFOURADDR_AUTO_BRG
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DRXF_DEQUEUE_ON_BUSY
endif
	DHDCFLAGS += -DWL_STATIC_IF
endif
endif

# CSI_SUPPORT
ifeq ($(CONFIG_CSI_SUPPORT),y)
	DHDCFLAGS += -DCSI_SUPPORT
	DHDOFILES += dhd_csi.o
endif

# For TPUT_IMPROVE
ifeq ($(CONFIG_BCMDHD_TPUT),y)
	DHDCFLAGS += -DDHD_TPUT_PATCH
	DHDCFLAGS += -DTCPACK_INFO_MAXNUM=10 -DTCPDATA_INFO_MAXNUM=10
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DDYNAMIC_MAX_HDR_READ
	DHDCFLAGS :=$(filter-out -DSDTEST,$(DHDCFLAGS))
endif
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DDHD_LB_TXP_DEFAULT_ENAB
	DHDCFLAGS += -DSET_RPS_CPUS -DSET_XPS_CPUS
	DHDCFLAGS += -DDHD_LB_PRIMARY_CPUS=0xF0 -DDHD_LB_SECONDARY_CPUS=0x0E
endif
endif

# For Zero configure
ifeq ($(CONFIG_BCMDHD_ZEROCONFIG),y)
	DHDCFLAGS += -DWL_EXT_GENL -DSENDPROB
	DHDOFILES += wl_ext_genl.o
endif

# For WAPI
ifeq ($(CONFIG_BCMDHD_WAPI),y)
	DHDCFLAGS += -DBCMWAPI_WPI -DBCMWAPI_WAI
ifeq ($(CONFIG_BCMDHD_ANDROID_VERSION),11)
	DHDCFLAGS += -DCFG80211_WAPI_BKPORT
endif
endif

# For scan random mac
ifneq ($(CONFIG_BCMDHD_RANDOM_MAC),)
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DSUPPORT_RANDOM_MAC_SCAN -DWL_USE_RANDOMIZED_SCAN
endif
endif

# For NAN
ifneq ($(CONFIG_BCMDHD_NAN),)
	DHDCFLAGS += -DWL_NAN -DWL_NAN_DISC_CACHE
	DHDOFILES += wl_cfgnan.o bcmbloom.o
endif

# For Module auto-selection
ifeq ($(CONFIG_BCMDHD_AUTO_SELECT),y)
	DHDCFLAGS += -DUPDATE_MODULE_NAME
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DGET_OTP_MODULE_NAME -DCOMPAT_OLD_MODULE
endif
endif

ifeq ($(CONFIG_BCMDHD),m)
	DHDCFLAGS += -DBCMDHD_MODULAR
endif

ifeq ($(CONFIG_MACH_PLATFORM),y)
	DHDOFILES += dhd_gpio.o
ifeq ($(CONFIG_BCMDHD_DTS),y)
	DHDCFLAGS += -DBCMDHD_DTS
endif
	DHDCFLAGS += -DCUSTOMER_HW -DDHD_OF_SUPPORT
endif

ifeq ($(CONFIG_BCMDHD_REQUEST_FW),y)
	DHDCFLAGS += -DDHD_LINUX_STD_FW_API
	DHDCFLAGS += -DDHD_FW_NAME="\"fw_bcmdhd.bin\""
	DHDCFLAGS += -DDHD_NVRAM_NAME="\"nvram.txt\""
	DHDCFLAGS += -DDHD_CLM_NAME="\"clm_bcmdhd.blob\""
else
ifeq ($(CONFIG_BCMDHD_FW_PATH),)
	DHDCFLAGS += -DCONFIG_BCMDHD_FW_PATH="\"/system/etc/firmware/fw_bcmdhd.bin\""
	DHDCFLAGS += -DCONFIG_BCMDHD_NVRAM_PATH="\"/system/etc/firmware/nvram.txt\""
	DHDCFLAGS += -DCONFIG_BCMDHD_CLM_PATH="\"/system/etc/firmware/clm_bcmdhd.blob\""
endif
endif

ifeq ($(CONFIG_BCMDHD_AG),y)
	DHDCFLAGS += -DBAND_AG
endif

ifeq ($(CONFIG_DHD_USE_STATIC_BUF),y)
ifeq  ($(CONFIG_BCMDHD_STATIC_BUF_IN_DHD),y)
	DHDOFILES += dhd_static_buf.o
	DHDCFLAGS += -DDHD_STATIC_IN_DRIVER
else
	obj-m += dhd_static_buf.o
endif
	DHDCFLAGS += -DSTATIC_WL_PRIV_STRUCT -DENHANCED_STATIC_BUF
	DHDCFLAGS += -DCONFIG_DHD_USE_STATIC_BUF
	DHDCFLAGS += -DDHD_USE_STATIC_MEMDUMP
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DDHD_USE_STATIC_CTRLBUF
endif
endif

ARCH ?= arm64
BCMDHD_ROOT = $(src)
#$(warning "BCMDHD_ROOT=$(BCMDHD_ROOT)")
EXTRA_CFLAGS = $(DHDCFLAGS)
EXTRA_CFLAGS += -DDHD_COMPILED=\"$(BCMDHD_ROOT)\"
EXTRA_CFLAGS += -I$(BCMDHD_ROOT)/include/ -I$(BCMDHD_ROOT)/
ifeq ($(CONFIG_BCMDHD),m)
EXTRA_LDFLAGS += --strip-debug
endif

obj-$(CONFIG_BCMDHD) += $(MODULE_NAME).o
$(MODULE_NAME)-objs += $(DHDOFILES)
ccflags-y := $(EXTRA_CFLAGS)

all: bcmdhd_pcie bcmdhd_sdio bcmdhd_usb

bcmdhd_pcie:
	$(warning "building BCMDHD_PCIE..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_PCIE=y

bcmdhd_sdio:
	$(warning "building BCMDHD_SDIO..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_SDIO=y

bcmdhd_usb:
	$(warning "building BCMDHD_USB..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_USB=y

modules_install:
	$(warning "installing modules...........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_install

clean:
	rm -rf *.o *.ko *.mod.c *~ .*.cmd *.o.cmd .*.o.cmd *.mod \
	Module.symvers modules.order .tmp_versions modules.builtin
