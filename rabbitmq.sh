#!/usr/bin/env bash
HOST="{{ common.amqp.server.host }}"
PORT="{{ common.amqp.server.managementPort }}"   # Management port, not direct AMQP!
VHOST="{{ common.amqp.server.virtualHost }}"
USER="{{ common.amqp.admin.username }}"
PASSWORD="{{ common.amqp.admin.password }}"

function exists(){
    command -v "$1" > /dev/null 2>&1
}

function registerAsCommand() {
    sudo cp 'rabbitmqadmin' '/usr/local/bin'
    sudo sh -c 'rabbitmqadmin --bash-completion > /etc/bash_completion.d/rabbitmqadmin'
    echo 'rabbitmqadmin is now registered as command'
}

function obtainRabbitMqAdmin() {
    if exists rabbitmqadmin; then
        echo 'rabbitmqadmin found [command]'
    else
        if [ -e rabbitmqadmin ]
        then
            echo 'rabbitmqadmin found [file]'
            registerAsCommand
        else
            echo 'rabbitmqadmin not found'
            wget "http://${HOST}:${PORT}/cli/rabbitmqadmin"
            if [ -e rabbitmqadmin ]
            then
                echo 'rabbitmqadmin found [downloaded from management interface]'
                registerAsCommand
            else
                echo "Error: cannot obtain rabbitmqadmin"
                exit 1
            fi
        fi
    fi
}


function dropVhost(){
    echo "Whoops! Drop vhost \"${VHOST}\"!!!!"
    rabbitmqadmin -H ${HOST} -P ${PORT} -u ${USER} -p ${PASSWORD} delete vhost name="${VHOST}"
}

function declareVhost(){
    rabbitmqadmin -H ${HOST} -P ${PORT} -u ${USER} -p ${PASSWORD} declare vhost name="${VHOST}"
    rabbitmqadmin -H ${HOST} -P ${PORT} -u ${USER} -p ${PASSWORD} list vhosts
}

function declareUsers() {
    echo 'Declare users'
    {% for u in common.amqp.users %}
        rabbitmqadmin -H ${HOST} -P ${PORT} -u ${USER} -p ${PASSWORD} \
          declare user name='{{ u.username }}' password='{{ u.password }}'  tags='{{ u.tags | join(',') }}'
        rabbitmqadmin -H ${HOST} -P ${PORT} -u ${USER} -p ${PASSWORD} \
          declare permission vhost="${VHOST}" user='{{ u.username }}' configure='.*' write='.*' read='.*'
    {% endfor %}
    rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} list users
    rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} list permissions
}

function declareExchanges() {
    echo 'Declare exchanges'
    {% for e in common.amqp.exchanges %}
        rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} \
          declare exchange name='{{ e.name }}' type='{{ e.type }}'  durable={{ e.durable|lower }} auto_delete={{ e.auto_delete|lower }} arguments='{{ e.arguments | tojson }}'
    {% endfor %}
    rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} list exchanges
}

function declareQueues() {
    echo 'Declare queues'
    {% for q in common.amqp.queues %}
        rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} \
          declare queue name='{{ q.name }}' durable={{ q.durable|lower }} auto_delete={{ q.auto_delete|lower }}
    {% endfor %}
    rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} list queues
}

function declareBindings() {
    echo 'Declare bindings'
    {% for b in common.amqp.bindings %}
        rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} \
          declare binding source='{{ b.exchange }}' destination='{{ b.queue }}' routing_key='{{ b.routing_key }}'
    {% endfor %}
    rabbitmqadmin -H ${HOST} -P ${PORT} -V ${VHOST} -u ${USER} -p ${PASSWORD} list bindings
}




# Here we go!
echo "Start declaring objects to RabbitMQ at $HOST"
obtainRabbitMqAdmin
dropVhost
declareVhost
declareUsers
declareExchanges
declareQueues
declareBindings
echo "Bye!"