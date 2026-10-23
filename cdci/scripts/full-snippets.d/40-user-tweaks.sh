#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Student user tweaks

function _install_home_config() {
	set -e
	# install labvm-dotfiles
	COMPONENTS=()
	if [[ "$USER" == "root" ]]; then COMPONENTS+=(-nvim); fi
	"$CDCI_SRC/files/labvm-dotfiles/install.sh" "${COMPONENTS[@]}"
}

_exported_script="$(declare -p CDCI_SRC); $(declare -f _install_home_config)"
for usr in student root; do
	echo "$_exported_script; _install_home_config" | su -c bash "$usr"
done
