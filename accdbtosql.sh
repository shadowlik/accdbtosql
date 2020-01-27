#!/bin/bash

# Variavéis para trocar
MUSER="root"
MPASS="loyall"
MHOST="192.168.20.243"
MDB="$2"

# Evitar log de aviso do mysql cli
export MYSQL_PWD=$MPASS

# Listamos as tabelas
TABLES=$(mdb-tables -1 $1)
MYSQL=$(which mysql)

# Criamos a pasta temporaria (ou não, dependendo da flag)
FOLDER="accdbtosql_$(date +"%s")"
mkdir $FOLDER

for t in $TABLES; do
    echo "Deletando a tabela ${t} caso exista"
    $MYSQL --host="$MHOST" --user="$MUSER" $MDB -e "DROP TABLE IF EXISTS ${t}"
done

# Criando o o schema da tabelas do banco
FILE_SCHEMA="${FOLDER}/${MDB}.sql"
echo "Criando schema do banco ${MDB} -> ${FILE_SCHEMA}"
mdb-schema $1 mysql > $FILE_SCHEMA
$MYSQL --host="$MHOST" --user="$MUSER" -e "SET names 'utf8'; SOURCE ${FILE_SCHEMA};" $MDB

for t in $TABLES; do
    FILE_TABLE="${FOLDER}/${MDB}_${t}_inserts.sql"
    echo "Criando sql de registros da tabela ${MDB}/${t} -> ${FILE_TABLE}"
    mdb-export -D '%Y-%m-%d %H:%M:%S' -I mysql $1 $t > $FILE_TABLE
    echo "Importando sql de registros da tabela ${MDB}/${t} -> ${FILE_TABLE}"
    $MYSQL --host="$MHOST" --user="$MUSER" -e "SET names 'utf8'; SOURCE ${FILE_TABLE};" $MDB
done

rm -R $FOLDER