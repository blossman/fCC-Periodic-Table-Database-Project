#!/bin/bash
#Return info for an element that is entered as argument via atomic number, Atomic symbol, or element name

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"