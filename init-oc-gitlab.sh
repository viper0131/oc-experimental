#####################################
#
#      G I T L A B
#
#####################################

#
# Add Gitlab from docker image
# (reference: https://about.gitlab.com/2016/06/28/get-started-with-openshift-origin-3-and-gitlab/ )
wget https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/docker/openshift-template.json

# The -n openshift namespace flag is a trick to make the template available to all projects.
# If you recall from when we created the gitlab project, oc switched to it automatically, and that can be verified by the oc status command.
# If you omit the namespace flag, the application will be available only to the current project, in our case gitlab.
# The openshift namespace is a global one that the administrators should use if they want the application to be available to all users.
oc create -f openshift-template.json -n openshift


oc project zgw-tools  # switch to project where we want to add gitlab
oc adm policy add-scc-to-user anyuid -z default
oc new-app gitlab/gitlab-ce
oc status
oc describe svc/gitlab-ce
oc get pods

#
# Deployment will fail first time because of limited right to run as root
# loosen restriction to run as root
# and deploy again
#
#oc adm policy add-scc-to-user anyuid -z default
#oc deploy gitlab-ce --latest

#
# create route
# gitlab-ce-zgw-tools.192.168.1.137.xip.io
#
oc expose service gitlab-ce
