set.seed(4321)
N<-2000
Q=c(0.1,0.5)
B<-1000000
ordered_x = 1:N
index_med<-matrix(NA,B,2)
for(b in 1:B){
  pois_temp=rpois(N,1)
  n<-round((sum(pois_temp)+1)*Q)
  index_med[b,]<-ifelse(round(n)==0,0,rep(ordered_x, pois_temp)[n])
}

temp<-cbind(table(index_med[,1]))
tib<-tibble(index=as.numeric(rownames(temp)), frequency=temp[,1])
ggplot(tib, aes(index,frequency))+
  geom_bar(stat = "identity")+
  scale_x_continuous(breaks=seq(140,260,10), labels = seq(140,260,10)) +
  labs(y = "Frequency",
       x = "Index of order statistic in the original sample") +
  theme_minimal()
ggsave("fig1.pdf", width = 6, height = 6*0.62)

tib<-tibble(index=index_med[,1], Distribution="Empirical")

tib2=tibble(index=rbinom(B,N+1,Q[1]), Distribution="Binomial(2001,0.1)")
tib<-bind_rows(tib,tib2)

ggplot(tib, aes(x=index,group=Distribution)) +
  geom_density(aes(color=Distribution,fill=Distribution,linetype=Distribution, alpha=Distribution), size=1) +
  labs(y = "Frequency", 
       x = "Index of order statistic in the original sample") +
  theme_minimal() +
  scale_fill_manual(values=c("grey90", "grey70")) +
  scale_color_manual(values=c(NA, "red")) +
  scale_linetype_manual(values=c(NA, "dotted")) +
  scale_alpha_manual(values=c(1, 0))
ggsave("fig2.pdf", width = 4, height = 4*0.85)

tib<-tibble(index=index_med[,2], Distribution="Empirical")

tib2=tibble(index=rbinom(B,N+1,Q[2]), Distribution="Binomial(2001,0.5)")
tib<-bind_rows(tib,tib2)
ggplot(tib, aes(x=index,group=Distribution)) +
  geom_density(aes(color=Distribution,fill=Distribution,linetype=Distribution, alpha=Distribution), size=1) +
  labs(y = "Frequency", 
       x = "Index of order statistic in the original sample") +
  theme_minimal() + 
  theme(legend.position = "none") +
  scale_fill_manual(values=c("grey90", "grey70")) +
  scale_color_manual(values=c(NA, "red")) +
  scale_linetype_manual(values=c(NA, "dotted")) +
  scale_alpha_manual(values=c(1, 0))
ggsave("fig3.pdf", width = 4, height = 4*0.85)
