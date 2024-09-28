#!/bin/bash
#Return info for an element that is entered as argument via atomic number, Atomic symbol, or element name

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#create function that will print all the data. 

#create function that will "get data"
GET_DATA () {
  #if read 1
  if [[ $1 == 1 ]]
  then
    #get everything from atomic number
    SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celcius, boiling_point_celcius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$2")
    echo $SEARCH_RESULT | PRINT_DATA
    #else if read 2
  else
    if [[ $1 == 2 ]]
    then
      #get everything from atomic symbol
      SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celcius, boiling_point_celcius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$2'")
      echo $SEARCH_RESULT | PRINT_DATA
      #else read 3
    else
      #get everything from name
      SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celcius, boiling_point_celcius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$2'")
      echo $SEARCH_RESULT | PRINT_DATA
    fi
  fi
}

#If no argument
if [[ -z $1 ]]
then
  #print message
  echo -e "\nPlease provide an element as an argument."
  #Else, see if argument is atomic number
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    #if yes, get other data
    GET_DATA 1 $ATOMIC_NUMBER
    #else see if atomic symbol
  else
    ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
    #if yes, get other data
    if [[ $ATOMIC_SYMBOL ]]
    then
      GET_DATA 2 $ATOMIC_SYMBOL
      #else see if element name
    else
      ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
      if [[ $ELEMENT_NAME ]]
      then
      #if yes, get other data
        GET_DATA 3 $ELEMENT_NAME
      #else print error 
      else
        echo -e "\nI could not find that element in the database."
      fi
    fi
  fi
fi



