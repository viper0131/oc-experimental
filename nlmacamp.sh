#oc delete project nlmacamp

#
# Create the project
#
oc new-project nlmacamp --display-name="Personal space of Machiel" \
                        --description="Development space of Machiel"
oc create serviceaccount nlmacamp
oc adm policy add-scc-to-user anyuid -z nlmacamp

#
# Create pljava image
#
#oc new-app /Users/viper/zgw/docker/postgres-PLJava --strategy=docker --name pljava
#oc new-build --to='pljava' ../docker/postgres-PLJava
#oc patch dc/pljava --patch '{"spec":{"template":{"spec":{"serviceAccountName": "nlmacamp"}}}}'
#oc start-build pljava --from-dir ../docker/postgres-PLJava

#
# Create Pegadb based on earlier created pljava image
oc new-app /Users/viper/zgw/docker/postgres-pegadb --strategy=docker --name pegadb \
  -e PG_PASSWORD="welkom" \
  -e DB_USER="pegabase" \
  -e DB_PASS="pega" \
  -e DB_NAME="pega" 
oc patch dc/pegadb --patch '{"spec":{"template":{"spec":{"serviceAccountName": "nlmacamp"}}}}'
oc start-build pegadb --from-dir ../docker/postgres-pegadb

#
# Pega version 7.2.1
#
oc new-build --to='pega-7.2.1' ../docker/pega-7.2.1
oc start-build --from-dir ../docker/pega-7.2.1 pega-721 -n nlmacamp -F --wait
oc patch dc/pega-7.2.1 --patch '{"spec":{"template":{"spec":{"serviceAccountName": "nlmacamp"}}}}'

#
# Pega version 7.2.2
#
#oc new-build --to='pega-7.2.2' ../docker/pega-7.2.2
#oc start-build --from-dir ../docker/pega-7.2.2 pega-722 -n nlmacamp -F --wait
#oc patch dc/pega-7.2.2 --patch '{"spec":{"template":{"spec":{"serviceAccountName": "nlmacamp"}}}}'

