# Interpolation, normalization and 364 day return rates of selected Mexican equity funds (from 31-12-2010 to 31-12-2015), the Mexican Stock Exchange (BMV, *Bolsa Mexicana de Valores*) and the 364 Days Treasury Certificates (CETES364D, *Certificados de la Tesorería a 364 días*) for the calculation of the funds' Modern Portfolio Theory (MPT) variables and a funds' clustering analysis

##MariaDB version 10.0.25
Platform: x86_64-suse-linux-gnu (64-bit)
>**MariaDB Foundation (2015)**. *Welcome to MariaDB! - MariaDB*.

>https://mariadb.org/

##Instructions
###Requirements:
* The database servers **MySQL Community Edition 5.5** or **MariaDB 10.0.25** must be installed:
>http://dev.mysql.com/downloads/mysql/

* Any database client, or graphical frontend, can be used; such as *MySQLWorkbench 6.3*:
>http://dev.mysql.com/downloads/workbench/

* In the database configuration file (`my.cnf`), the next lines must be added to allow the direct load of data from text files and to discard errors in the creation of dinamic tables that are used by some StoreProcedures:
  >After section:

  > `** [mysqld] **`


  >Add:

  > `# Security warning: allow LOAD DATA INFILE`

  > `loose-local-infile=1`

  > `# To allow for slow queries, queries with big columns or with calculated tables (64M)`

  > `max_allowed_packet = 67108864`


  > **NOTE:** Keep a copy of the original configuration file "`my.cnf`".

* In the configuration of *Workbench*, go to 'Edit->Preferences...->SQL Editor' and in the option 'DBMS connection read time out (in seconds)' change from 600 to **86400**.
  * The interpolation process is slow; without this change, the interpolation process will remain incomplete after 10 minutes.
  * In case of ussing another graphic database client, search for the option that allows to increase the query delay time in the configuration preferences.


###Execution instructions:
####Script files:
* `1_crea_basededatos.sql`
* `2_carga_datos_bmv.sql`
* `2_carga_datos_extra.sql`
* `2_carga_datos.sql`
* `2_carga_datos_tasas.sql`
* `3_1_fn_y_sp.sql`
* `3_2_fn_y_sp_bmv.sql`
* `3_2_fn_y_sp_extra.sql`
* `3_2_fn_y_sp_tasas.sql`
* `3_interpola_datos_bmv.sql`
* `3_interpola_datos_extra.sql`
* `3_interpola_datos.sql`
* `3_interpola_datos_tasas.sql`
* `4_normaliza_datos_bmv.sql`
* `4_normaliza_datos.sql`
* `5_calcula_tasas_retorno_bmv.sql`
* `5_calcula_tasas_retorno_de_tasas.sql`
* `5_calcula_tasas_retorno.sql`
* `db.RVMexico.sql`

####Data backup files:
* `RVMexico.market.csv`
* `RVMexico.market_interpolated.csv`
* `RVMexico.market_normalized.csv`
* `RVMexico.market_return_rates.csv`
* `RVMexico.market_rrates.csv`
* `RVMexico.market_rrates_interpolated.csv`
* `RVMexico.market_rrates_return_rates.csv`
* `RVMexico.prices.csv`
* `RVMexico.prices_interpolated.csv`
* `RVMexico.prices_normalized.csv`
* `RVMexico.prices_return_rates.csv`

####The script files must be exetuted in the graphic client in the next order:
1. `1_crea_basededatos.sql`
> Creates the database schema and tables to store the original historic price data, the interpolated data, the normalized data and the annual return rates.

  * **Database:**
    * RVMexico
  * **Tables:**
    * prices
    * prices_interpolated
    * prices_normalized
    * prices_return_rates
    * market
    * market_interpolated
    * market_normalized
    * market_return_rates
    * market_rrates
    * market_rrates_interpolated
    * market_rrates_return_rates

2. `2_carga_datos.sql`, `2_carga_datos_bmv.sql`, `2_carga_datos_extra.sql` and `2_carga_datos_tasas.sql`
> These scripts load the downloaded funds' historical price information in the database need to begin the data preprocessment. Use acording to their instructions.

3. `3_1_fn_y_sp.sql`, `3_2_fn_y_sp_bmv.sql`, `3_2_fn_y_sp_extra.sql` and `3_2_fn_y_sp_tasas.sql`
> This scripts have the functions and store procedures used in the interpolation, normaliations and yearly return rates calculation process.

  * **Functions:**
    * fn_interpolation
  * **Store procedures:**
    * a_fillin_dates
    * a_fillin_dates_from_last_date
    * a_fillin_dates_market
    * a_fillin_dates_market_rrates
    * a_fillin_dates_per_found
    * a_fillin_dates_per_found_from_date
    * a_fillin_dates_per_index
    * a_fillin_dates_per_index_rrates
    * b_interpolate_prices
    * b_interpolate_prices_per_found
    * b_interpolate_prices_from_last_date
    * b_interpolate_prices_per_found_from_date
    * b_interpolate_index_prices
    * b_interpolate_prices_per_index
    * b_interpolate_index_rrates
    * b_interpolate_rrates_per_index
    * c_normalize_prices
    * c_normalize_prices_market
    * d_market_yearly_return_rates
    * d_prices_yearly_return_rates
    * d_rrates_yearly_return_rates

4. `3_interpola_datos.sql`, `3_interpola_datos_extra.sql`, `3_interpola_datos_bmv.sql` and `3_interpola_datos_tasas.sql`
> These scripts containt the instructions to execute the funds' price interpolation process. Use acording to their instructions.

5. `4_normaliza_datos.sql` and `4_normaliza_datos_bmv.sql`
> These scripts containt the instructions to execute the funds' price normalization process. Use acording to their instructions.

6. `5_calcula_tasas_retorno.sql`, `5_calcula_tasas_retorno_bmv.sql` and `5_calcula_tasas_retorno_de_tasas.sql`
> These scripts containt the instructions to execute the funds' yearly return rates calculation process. Use acording to their instructions.

###Important notes:
> To just recreate the database, without needing to repeat the data preprocessing process, execute the scritps in the order:
  1. `1_crea_basededatos.sql`
  2. `db.RVMexico.sql`
