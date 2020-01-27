# Migrando banco de dados Microsoft Access para SQL

Recentemente tive a necessidade de migrar um banco de dados access para SQL, com pouco mais de 1gb de tamanho levou cerca de 2 horas para completar a migração. O script tem alguns ajustes que sacrificam performance afim de manter a consistência do charset, tive muitos propelmas com pipe e stream no linux então resolvi fazer da maneira segura para os dados.

## Pré-requisitos

[mdb-tools](https://github.com/brianb/mdbtools)

## Como usar

Edite as variáveis com os dados de conexão do seu banco de dados e no terminal:

> sh accdbtosql.sh [arquivo-access] [banco-de-dados]