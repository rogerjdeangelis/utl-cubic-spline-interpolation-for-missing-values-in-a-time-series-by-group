Cubic spline interpolation for missing values in a time series by group                                   
                                                                                                          
Related to                                                                                                
SAS forum                                                                                                 
https://tinyurl.com/y5y8awdw                                                                              
https://communities.sas.com/t5/SAS-Programming/Fill-in-a-date-table-from-a-specific-date/m-p/584534       
                                                                                                          
*_                   _                                                                                    
(_)_ __  _ __  _   _| |_                                                                                  
| | '_ \| '_ \| | | | __|                                                                                 
| | | | | |_) | |_| | |_                                                                                  
|_|_| |_| .__/ \__,_|\__|                                                                                 
        |_|                                                                                               
;                                                                                                         
                                                                                                          
options validvarname=upcase;                                                                              
libname sd1 "d:/sd1";                                                                                     
data sd1.have;                                                                                            
  input name $ date :anydtdte7. value;                                                                    
format date yymmdd10.;                                                                                    
datalines;                                                                                                
NAME1 12/2017 2                                                                                           
NAME1 03/2018 1                                                                                           
NAME1 06/2018 3                                                                                           
NAME2 01/2018 3                                                                                           
NAME2 05/2018 4                                                                                           
NAME2 07/2018 1                                                                                           
;;;;                                                                                                      
run;quit;                                                                                                 
                                                                                                          
 SD1.HAVE total obs=6                                                                                     
                                                                                                          
   NAME      DATE    VALUE                                                                                
                                                                                                          
   NAME1   12/2017     2                                                                                  
   NAME1   03/2018     1                                                                                  
   NAME1   06/2018     3                                                                                  
   NAME2   01/2018     3                                                                                  
   NAME2   05/2018     4                                                                                  
   NAME2   07/2018     1                                                                                  
                                                                                                          
*            _               _                                                                            
  ___  _   _| |_ _ __  _   _| |_                                                                          
 / _ \| | | | __| '_ \| | | | __|                                                                         
| (_) | |_| | |_| |_) | |_| | |_                                                                          
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                         
                |_|                                                                                       
;                                                                                                         
                                                                                                          
WORK.WANT total obs=14                                                                                    
                                                                                                          
  NAME      DATE       VALUE                                                                              
                                                                                                          
  NAME1    12/2017    2.00000                                                                             
  NAME1    01/2018    0.82039  * filled in gaps with spline interpolation                                 
  NAME1    02/2018    0.58230                                                                             
  NAME1    03/2018    1.00000                                                                             
  NAME1    04/2018    1.77553                                                                             
  NAME1    05/2018    2.56194                                                                             
  NAME1    06/2018    3.00000                                                                             
                                                                                                          
  NAME2    01/2018    3.00000                                                                             
  NAME2    02/2018    3.28331                                                                             
  NAME2    03/2018    3.77335                                                                             
  NAME2    04/2018    4.12673                                                                             
  NAME2    05/2018    4.00000                                                                             
  NAME2    06/2018    3.05819                                                                             
  NAME2    07/2018    1.00000                                                                             
                                                                                                          
*                                                                                                         
 _ __  _ __ ___   ___ ___  ___ ___                                                                        
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                       
| |_) | | | (_) | (_|  __/\__ \__ \                                                                       
| .__/|_|  \___/ \___\___||___/___/                                                                       
|_|                                                                                                       
;                                                                                                         
                                                                                                          
%utl_submit_r64('                                                                                         
library(haven);                                                                                           
library(imputeTS);                                                                                        
library(dplyr);                                                                                           
library(tidyr);                                                                                           
library(SASxport);                                                                                        
have<-read_sas("d:/sd1/have.sas7bdat");                                                                   
str(have);                                                                                                
xpand<-as.data.frame(have %>%                                                                             
  group_by(NAME) %>%                                                                                      
  complete(DATE = seq.Date(min(DATE), max(DATE), by="month")));                                           
want<-as.data.frame(xpand %>% group_by(NAME) %>% na_interpolation(option = "spline"));                    
write.xport(want,file="d:/xpt/want.xpt");                                                                 
');                                                                                                       
                                                                                                          
libname xpt xport "d:/xpt/want.xpt";                                                                      
data want ;                                                                                               
  set xpt.want;                                                                                           
  format date mmyys7.;  ;                                                                                 
  value=sum(0,value);                                                                                     
run;quit;                                                                                                 
libname xpt clear;                                                                                        
                                                                                                          
                                                                                                          
