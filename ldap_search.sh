#!/bin/bash

# -------------------------------------------------------------
# List all the LDAP groups/users containing a specific policy
# -------------------------------------------------------------

# export VAULT_ADDR='YOUR_VAULT_URL'
# export VAULT_TOKEN="YOUR_USER_TOKEN"

# ------
TYPE=$1
POLICY=$2

if [[ -z $VAULT_ADDR || -z $VAULT_TOKEN ]];
then
    echo " - Missing environment variables: VAULT_ADDR or VAULT_TOKEN. "
    exit 1
fi

if [[ -z $TYPE || -z $POLICY ]];
then
    echo " - Missing mandatory argument: 'policy_to_search' "
    echo " - Usage: ./$0  [ldap_type (group|user) ] [policy_to_search (id|ALL) ] "
    exit 1
fi
# ------

RESULT=""

groups_list=`curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request LIST \
    $VAULT_ADDR/v1/auth/ldap/groups | jq .data.keys `

while read group; do
    echo " > $group"
    group_detail=`curl --silent \
        --header "X-Vault-Token: $VAULT_TOKEN" \
        $VAULT_ADDR/v1/auth/ldap/groups/$group | jq .data.policies`

    if [[ $group_detail == *"$POLICY"* ]]; then
        RESULT+="$group,"
    fi    
done <<< "$(echo $groups_list | jq -r '.[]')"
# The while loop is executed in a subshell. So any changes you do to the variable will not be available once the subshell exits.
# Instead you can use a "here string" to re-write the while loop to be in the main shell process; only "$(echo $groups_list | jq -r '.[]')" will run in a subshell


echo " "
echo " LDAP groups containing the policy '$POLICY'"
echo "---------------------------------------------"
echo "$RESULT"
echo "---------------------------------------------"
