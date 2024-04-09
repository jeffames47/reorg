# This playbook will: rollback snow
# Last modified:  3/24

- hosts: "{{envVar}}:&{{applicationVar}}"
  gather_facts: true
  become: yes
  pre_tasks:
    - name: Include all main.yaml file for the ENV
      include_vars: "vars/{{envVar}}/main.yml"
    - name: Include file for the Env/Application
      include_vars: "vars/{{envVar}}/{{applicationVar}}.yml"
  tasks:
    - name: remove /opt/snow/NaviHealth/Linux/naviHealth_snowagent-sios-6.2.3-1.x86_64.rpm
      shell: rm -rf /opt/snow/NaviHealth/Linux/naviHealth_snowagent-sios-6.2.3-1.x86_64.rpm
      args:
        warn: no
    - name: remove opt/snow
      shell: rm -rf /opt/snow
      args:
        warn: no
    - name: remove /usr/local/snow.sh
      shell: rm -rf /usr/local/snow.sh
      args:
        warn: no
    - name: remove snow/NaviHealth.zip
      shell: rm -rf /opt/snow/NaviHealth.zip
      args:
        warn: no
