#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Appointment Sheulder ~~~~~\n"

MAIN_MENU()
{
    if  [[ $1 ]]
    then echo -e "\n$1"
    fi

    AV_SERVICES=$($PSQL "SELECT * FROM services");
    echo "$AV_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
    echo "$SERVICE_ID) $SERVICE_NAME"
    done

    echo -e "\nChoose your service:"
    read SERVICE_ID_SELECTED

    #validate inptu

    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9+$] ]]
    then
    MAIN_MENU "Your selection is not a valid number"
    else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

    if [[ -z $SERVICE_NAME ]]
    then
    MAIN_MENU "This service is not avaible"
    else
    echo -e "\nPlease enter a customer phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
    #adding a new customer
    echo -e "\nEnter a customer name:"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
    
    echo -e "\nInsert time of the service:"
    read SERVICE_TIME

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

    if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
    then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi

    fi

    fi
    
    

}

MAIN_MENU