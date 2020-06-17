library(dplyr)
library(lme4)
library(ggplot2)
library(ggpubr)
data("CCcolors")
names(CCcolors) = c('A/J', 'C57BlL/6J', '129S1/SvImJ', 'NOD/ShiLtJ', 'NZO/HlLtJ', 'Cast/EiJ', 'PWK/PhJ', 'WSB/EiJ')

MRISpead<-read.csv("~/Documents/Projects/KidneyRelated/MRI/DataFromLM/MRIDataSpread.csv")
> View(MRISpead)
> MRIClean<-MRISpead %>% select(AnimalID,Strain,Sex,Age,AnimalInjectionBatch,Injection.Order,InjectionScoreAdd,PerfusionScore,MRIBatch,GlomNumber,Weight,Kidney)


# Two potential Data transformations to explore 
MRIClean$GlomNumberLog <-log(MRIClean$GlomNumber)
MRIClean$GlomNumberScale <-scale(MRIClean$GlomNumber,center = TRUE, scale = TRUE)


Simnplified1Model<-glmer(GlomNumberScale~Strain*Sex+Kidney+Weight+(1|MRIBatch)+(1|AnimalInjectionBatch)+(1|Injection.Order),data=MRIClean)

getME(GoodModel,"ALL")


qqnorm(resid(Simnplified1Model))
qqline(resid(Simnplified1Model))

GlomNumber<- ggplot(data=MRICLean,mapping = aes(x=Strain,y=mu))+geom_point(aes(shape=Sex,color=Strain, size=1))+scale_color_manual(values=CCcolors)+theme_bw()+geom_smooth(method="lm")+facet_grid(~Sex)