ks<-read.table("query_results/kmer_stats_all.tab")
names(ks)<-c("category","hits","count")
ks<-aggregate(ks$count, list(ks$category,ks$hits), sum)
names(ks)<-c("category","hits","count")

library(lattice)

p1<-barchart(count~hits |category,
        data=subset(ks,category!="no_rank"),
        horizontal=FALSE,
        subset=hits<60,
        #groups=seed,
        scales=list(alternating=FALSE,#y=list(rot=120,cex=0.5),
                    x=list(relation="free",cex=0.5),
                    y=list(log=10)),
        xlab="kmer.hits",
    auto.key=list(columns=3,cex=0.7)
    )

png("plots/kmer_all_stats_all.png",width=3000,height=1000,res=120)
print(p1)
dev.off()

ks.genome<-subset(ks,category=="genome")
breaks<-c(1:16,32,50,100,150,200,max(ks.genome$hits))
ks.genome$hits<-cut(ks.genome$hits,breaks) #,labels=breaks)
ks.genome<-with(ks.genome,aggregate(count, list(category,hits), sum))
names(ks.genome)<-c("category","hits","count")

p1<-barchart(count~hits |category,
        data=ks.genome,
        horizontal=FALSE,
        #subset=hits<60,
        #groups=seed,
        scales=list(alternating=FALSE,tick.number=6,#y=list(rot=120,cex=0.5),
                    x=list(relation="free",cex=0.7),
                    y=list(log=10)),
        xlab="kmer.hits",
    auto.key=list(columns=3,cex=0.7)
    )

png("plots/kmer_all_stats_genome.png",width=1500,height=1000,res=120)
print(p1)
dev.off()