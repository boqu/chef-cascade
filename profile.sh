# functions to enable/disable chef dev environment

chefdev_enable() {
  if ! echo "$PATH" | grep "chef-cascade"; then
    export PATH=/opt/chef-cascade/gems/bin:$PATH
  fi

  if ! echo "$GEM_PATH" | grep "chef-cascade"; then
    export GEM_PATH=/opt/chef-cascade/gems
  fi
}

chefdev_disable() {
  export PATH=$(echo "$PATH" | sed 's/\/opt\/chef-cascade\/gems\/bin://')
  unset GEM_PATH
}
