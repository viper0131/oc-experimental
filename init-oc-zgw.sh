#
# Setup ZGW cluster
#
./start-oc-zgw.sh

ll ~/.oc/profiles/

oc version

#
# More power.....
#
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm policy add-cluster-role-to-user cluster-admin developer
oc cluster status  
oc login https://localhost:8443 -u developer -p developer

