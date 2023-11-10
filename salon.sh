#! /bin/bash

PSQL='psql  --username=freecodecamp --dbname=salon -t  -c'

echo -e "\n~~ Salon ~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "$1"
  fi
  
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  
  echo "$SERVICES" |  while IFS='|' read ID NAME
  do
    echo  "$ID) $NAME" | sed -E 's/^ +|^\([0-9]+ rows\)\)//g' | sed -E 's/ \) /\)/'
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) COLOR ;;
    3) PERM ;;
    4) STYLE ;;
    5) TRIM ;;
    *) MAIN_MENU "\nI could not find that service. What would you like today?\n" ;;
  esac
}

CUT() {
  
  SERVICE_NAME='cut'
 PHONE
}
COLOR() {
  
  SERVICE_NAME='color'
 PHONE
}
PERM() {
  
  SERVICE_NAME='perm'
 PHONE
}
STYLE() {
  
  SERVICE_NAME='style'
  PHONE
}
TRIM () {
  
  SERVICE_NAME='trim'
  PHONE
}

PHONE() {
#get the phone
echo -e "\nWhat's your phone number?\n"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

# if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
  # get new customer name
  echo -e "\nI don't have a record for that phone number, what's your name?\n"
  read CUSTOMER_NAME
  # insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
fi
#get customer id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE  phone = '$CUSTOMER_PHONE' ")

#get the time for the appointments
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?\n" | sed 's/  / /g'
read SERVICE_TIME

#Insert the appointments
INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID , '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n" | sed 's/  / /g'

}

MAIN_MENU