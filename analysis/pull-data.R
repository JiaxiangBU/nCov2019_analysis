## -------------------------------------------------------------------------------------------------
data_repo <- git2r::repository(here::here("../DXY-2019-nCoV-Data"))


## -------------------------------------------------------------------------------------------------
library(magrittr)
library(git2r)
data_repo %>% 
    pull()


## ----eval=FALSE-----------------------------------------------------------------------------------
## rstudioapi::getActiveDocumentContext()$path %>%
##     knitr::purl()

