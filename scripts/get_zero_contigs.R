
lens<-read.table("data/results_SRR061958.sample50K.fa.bam_block_lens.csv")
nums<-read.table("data/results_SRR061958.sample50K.fa.bam_block_nums.csv")

library(lattice)

p1<-histogram(~lens,xlab="Lengths of zero blocks")

png("plots/zero_block_lengths.png")
plot(p1)
dev.off()

p1<-histogram(~nums,
breaks=0:15,
xlab="Number of zero blocks in a read")
png("plots/zero_block_nums.png")
plot(p1)
dev.off()