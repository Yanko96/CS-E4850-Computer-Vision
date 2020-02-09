function result=NCCSimilarity(patchA,patchB)
mean_a=mean(mean(patchA));
mean_b=mean(mean(patchB));
patchA_nor=patchA-mean_a;
patchB_nor=patchB-mean_b;
result=sum(sum(patchA_nor.*patchB_nor))/sqrt(sum(sum(patchA_nor.^2))*sum(sum(patchB_nor.^2)));
end