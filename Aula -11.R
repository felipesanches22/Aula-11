#Aula 11
remove.packages(c("ggplot2", "data.table"))
install.packages('Rcpp', dependencies = TRUE)
install.packages('ggplot2', dependencies = TRUE)
install.packages('data.table', dependencies = TRUE)

install.packages("Hmisc")      #Instala Pacote Hmisc  
install.packages("forecast")
library(Hmisc)
library(forecast)
library(readxl)               #Carrega os Pacotes


IPCA.df<-read_excel("c:/Econometria/IPCA.xls")                       #Carrega o arquivo
plot(IPCA.df$IPCA, type = "l")                                       #Cria um gr�fico do arquivo
MM <- data.frame(na.omit(ma(IPCA.df$IPCA,order = 12, centre = T)))   #Cria  uma serie de m�dias m�veis tradicionais omitindo oa NAS de lag(N)=12    

acf(IPCA.df)
pacf(IPCA.df)


a <- (127-nrow(MM))+1                                                #Define um par�metro a para ponderar as perdas de dados para pondera��o da m�dia
IPCA.DF <- as.data.frame(IPCA.df$IPCA[a:127])                        #Define IPCA.DF como uma vetor do mesmo tamanho que o vetor das m�dias m�veis MM
Tabela1 <- cbind(IPCA.DF,MM)                                         #Cria a Tabela de Dados Tabela1
colnames(Tabela1) <- c("IPCA","M�dia M�vel")
View(Tabela1)

Grafico <- ts(Tabela1, start = 2008, frequency = 12)                 #Cria a Serie Temporal "Grafico" mensal iniciando em 2008

plot(Grafico, plot.type= "single", col=c("Black","Blue"))            #Cria o gr�fico da s�rie de dados e de m�dias m�veis conjuntamente.
z <- lm(IPCA.df$IPCA~IPCA.df$Ano.M�s)                                #Regride os dados em rela��o ao tempo e verifica a tend�ncia
abline(z, col="Green")                                               #Coloca a linha de regress�o de tend�ncia no gr�fico
summary(z)

tabela2 <- as.data.frame(Tabela1$IPCA/Tabela1$`M�dia M�vel`)
plot(tabela2)

Inflacao <- ts(IPCA.df$IPCA, start = 2008, frequency = 12)

decomposicao <- decompose(Inflacao)                                          #Decomp�e a s�rie em Ciclo, Tend�ncia e Sazonalidade

plot(decompose(Inflacao))  

Tendencia <- decomposicao$trend

Sazonalidade <- decomposicao$seasonal

Ciclo <- decomposicao$random

Tab_Dados1 <- data.frame(IPCA.df$IPCA, Ciclo)

View(Tab_Dados1)

plot(Sazonalidade, type="l")

Serie_Tempo1 <- ts(Tab_Dados1, start = 2008, frequency = 12)
plot(Serie_Tempo1, plot.type = "single", col= c("Blue", "Red"))

Tab_Dados2 <- data.frame(IPCA.df$IPCA, Tendencia)
Serie_Tempo2 <- ts(Tab_Dados2, start = 2008, frequency = 12)
plot(Serie_Tempo2, plot.type = "single", col= c("Blue", "Red"))