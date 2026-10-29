## Makefile for CDCI lab VMs
##

FRAMEWORK_DIR ?= ./framework
include $(FRAMEWORK_DIR)/framework.mk
include $(FRAMEWORK_DIR)/lib/inc_all.mk

# set default goals
DEFAULT_GOAL = labvm
INIT_GOAL = labvm
SUDO ?= sudo

# Fresh Ubuntu base VM
$(call vm_new_base_ubuntu,base)
base-ver = 26.04

labvm-ver = $(CDCI_LABVM_VERSION)$(ARCH_SUFFIX)
labvm-prefix = CDCI_$(labvm-ver)

# VM with CDCI lab customizations
$(call vm_new_layer_full_featured,labvm)
labvm-name = $(labvm-prefix)
labvm-src-from = base
labvm-script-prepare = cdci-prepare.sh
labvm-copy-scripts += $(abspath ./cdci/scripts)/
labvm-extra-rules += $(vm_zerofree_rule)

# Export to VirtualBox & VMware
localvm-name = $(labvm-prefix)_Local
localvm-type = vm-combo
localvm-vmname = CDCI $(labvm-ver) VM
localvm-src-from = labvm
localvm-extra-rules += $(vm_zerofree_rule)

# Cloud-init image
$(call vm_new_layer_cloud,cloud)
cloud-name = $(labvm-prefix)_cloud
cloud-src-from = labvm
cloud-copy-scripts += $(abspath ./cloud/scripts)/
cloud-extra-envs = "CDCI_CLOUD_ADMIN_PASSWORD=$(CDCI_CLOUD_ADMIN_PASSWORD)",
cloud-extra-rules += $(vm_zerofree_rule)

# Flatten cloud image (remove backing file reference for OpenStack upload)
define vm_cloud_flatten_rule
.PHONY: $(vm)_flatten
$(vm)_flatten: $$($(vm)-dest-image)
	@echo "Flattening cloud image (removing backing file)..."
	qemu-img convert -c -O qcow2 "$$($(vm)-dest-image)" "$$($(vm)-dest-image:.qcow2=_flat.qcow2)"
	mv "$$($(vm)-dest-image:.qcow2=_flat.qcow2)" "$$($(vm)-dest-image)"
	@echo "Done! Standalone image: $$($(vm)-dest-image)"
	ls -lh "$$($(vm)-dest-image)"

endef
cloud-extra-rules += $(vm_cloud_flatten_rule)

# list with all VMs to generate rules for (note: use dependency ordering!)
build-vms = base labvm localvm cloud

$(call vm_eval_all_rules)
