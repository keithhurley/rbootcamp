library("tidyverse")
library("jsonlite")
library("maps")

spp<-"spp=walleye"
county<-"county="
wb<-"wb="
before<-"before="
after<-"after=2016"

UrlBase<-"http://fishstaff.nebraska.gov/mvc/api/Stockings/GetStockingsPublic"
URL<-paste(UrlBase,"?", spp, "&", county, "&", wb, "&", before, "&", after, sep="")

stk<-fromJSON(URL)
stk
View(stk)

stk<-stk$data

stk<-stk %>%
  mutate(stkWaterbody=factor(stkWaterbody), stkCounty=factor(stkCounty)) %>%
  filter(stkSize < 13)

stk$sizeBin[stk$stkSizeCategory=="Fry"]<-"Fry"
stk$sizeBin[stk$stkSizeCategory=="Fish" & stk$stkSize <5]<-"1-4"
stk$sizeBin[stk$stkSizeCategory=="Fish" & stk$stkSize >=5 & stk$stkSize < 13]<- "5-13"

op<-stk %>%
  mutate(sizeBin=as.factor(sizeBin)) %>%
    select(County=stkCounty, stkNumber, sizeBin) %>%
  group_by(County, sizeBin) %>%
  summarise(tot=sum(stkNumber)) %>%
  mutate(totK=tot/1000) %>%
  filter(!is.na(sizeBin))

ggplot(data=op) +
  geom_bar(aes(x=County, y=totK, fill=sizeBin), stat="identity") +
  theme_bw() +
  theme(axis.text.x=element_text(angle=90, hjust=0, vjust=0.5))

library("maps")

nebr<-map_data("county") %>%
  filter(region=="nebraska")

op$County<-tolower(op$County)

op <- op %>%
  right_join(nebr, by=c("County"="subregion"))

ggplot(data=op[!is.na(op$tot),]) +
  geom_polygon(data=nebr, aes(x=long, y=lat, group=group), color="black", fill=NA) +
  geom_polygon(aes(x=long, y=lat, group=group, fill=tot)) +
  scale_fill_continuous(low="red", high="yellow", na.value="NA") +
    coord_equal() +
  theme_void() +
  facet_wrap(~sizeBin, ncol=1)
