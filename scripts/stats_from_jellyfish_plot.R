

js<-read.table("stats_from_jellyfish.csv")
names(js)<-c("kmer.count","kmer.mult","seed")

library(lattice)
p1<-barchart(kmer.count~kmer.mult #| cut(kmer.mult,12),
        ,data=js,
        horizontal=FALSE,
        subset=kmer.mult<70,
        groups=seed,
        scales=list(#y=list(rot=120,cex=0.5),
                    x=list(relation="free"),
                    y=list(log=10)),
    auto.key=list(columns=3,cex=0.7)
                    )
png("plots/jellyfish_stats_3seeds.png",width=1600,height=800,res=125)
print(p1)
dev.off()


for (i in 1:5){
subs<-with(js,kmer.mult>=70*i & kmer.mult<70*(i+1))

p1<-barchart(kmer.count~kmer.mult #| cut(kmer.mult,12),
        ,data=js,
        horizontal=FALSE,
        subset=subs,
        groups=seed,
        scales=list(#y=list(rot=120,cex=0.5),
                    x=list(relation="free",labels=js$kmer.mult[subs],cex=0.5),
                    y=list(log=10)),
    auto.key=list(columns=3,cex=0.7)
                    )
png(paste("plots/jellyfish_stats_3seeds",i,".png",sep=""),width=1600,height=800,res=125)
print(p1)
dev.off()
}

attach(js)
res<-t(tapply(kmer.count,list(seed,cut(log10(kmer.mult),5)),FUN=sum))%*%diag(1/tapply(kmer.count,list(seed),FUN=sum))
res<-data.frame(res)
colnames(res)<-levels(seed)
rownames(res)<-c(paste("(",round(10^-0.00285,1),",",round(10^0.569,1),"]",sep=""),
paste("(",round(10^0.569,1),",",round(10^1.14,1),"]",sep=""),
paste("(",round(10^1.14,1),",",round(10^1.71,1),"]",sep=""),
paste("(",round(10^1.71,1),",",round(10^2.28,1),"]",sep=""),
paste("(",round(10^2.28,1),",",round(10^2.85,1),"]",sep=""))

res.long<-reshape(res,idvar="kmer.mult",ids=row.names(res),times=colnames(res),timevar="seed",varying=list(colnames(res)),direction="long")
colnames(res.long)[2]<-"kmer.count"
res.long<-res.long[order(res.long$kmer.count),]

x<-factor(res.long$kmer.mult)
res.long$kmer.mult<-factor(x,levels(x)[c(1,4,2,5,3)])

p1<-barchart(kmer.count~kmer.mult #| cut(kmer.mult,12),
        ,data=res.long,
        horizontal=FALSE,        
        groups=seed,
        scales=list(#y=list(rot=120,cex=0.5),
                    x=list(relation="free")),
                    #y=list(log=10)),
    auto.key=list(columns=3,cex=0.7)
                    )
png(paste("plots/jellyfish_stats_3seeds_percents.png",sep=""),width=1200,height=800,res=125)
print(p1)
dev.off()
detach()

