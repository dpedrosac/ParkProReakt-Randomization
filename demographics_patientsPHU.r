# This is code to run analyses for the protocol for ParkProReakt;
# https://innovationsfonds.g-ba.de/projekte/neue-versorgungsformen/parkproreakt-proaktive-statt-reaktive-symptomerkennung-bei-parkinson-patientinnen-und-patienten.432
# Code developed by David Pedrosa

# Version 1.0 # 2021-12-27

## First specify the packages of interest
packages = c("readxl", "tableone", "dplyr", "tidyverse", "rstatix", "Hmisc") #

## Now load or install&load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

## In case of multiple people working on one project, this helps to create an automatic script
username = Sys.info()["login"]

if (username == "dpedr") {
	wdir = "D:/innofonds_protocol"
} else if (username == "david") {
	wdir = "/media/storage/innofonds_protocol/"
}
setwd(wdir)
df 				    <- read_excel(file.path(wdir, "ambulanz.G20.2019to2021.xlsx")) # read data frame from xlsx-file

df$gender 			<- as.factor(df$gender)
levels(df$gender) 	<- c("male", "female")

df$icd 					<- as.factor(df$icd) # factors according to: https://gesund.bund.de/en/icd-code-search/g20-9
df$icd_cat 		<- as.factor(df$icd) # factors according to: https://gesund.bund.de/en/icd-code-search/g20-9
levels(df$icd_cat) 		<- c(	"Primary Parkinson disease with no or mild impairment - with no fluctuations", 
							"Primary Parkinson disease with no or mild impairment - with fluctuations", 
							"Primary Parkinson disease with moderate to severe impairment - with no fluctuation ", 
							"Primary Parkinson disease with moderate to severe impairment - with fluctuations",
							"Primary Parkinson disease with severest impairment - with no fluctuation ",
							"Primary Parkinson disease with severest impairment - with fluctuations",
							"Primary Parkinson disease, unspecified - with no fluctuation",
							"Primary Parkinson disease, unspecified - with fluctuations")


# ==================================================================================================
## Create TableOne for specific values
Vars 			<- c("icd", "age", "gender", "h&y", "bdi", "moca", "pdq8")
nonnormalVars 	<- c("h&y") # avoids returning mean in favor of median 
factVars 		<- c("gender", "icd", "h&y") # Here only values with categorial (ordinal distribution should be added) 
tableOne 		<- CreateTableOne(vars=Vars, factorVars=factVars, data=df) 
print(tableOne, nonnormal=c("h&y"))

# 
df_corr <- df %>%
  select(c("h&y", "age", "bdi", "moca", "pdq8"))
rcorr(as.matrix(sapply(df_corr, as.numeric)))

