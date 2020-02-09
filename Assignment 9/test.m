learning_rate=[0.002, 0.01, 0.05, 0.2, 1.0, 5.0, 20.0];
momentum_multiplier=[0,0.9];
for i=1:7
    for j=1:2
        disp(['The learning rate for this experiment is ',num2str(learning_rate(i)),' and momentum ',num2str(momentum_multiplier(j))])
        a2(0, 10, 70, learning_rate(i), momentum_multiplier(j), false, 4) 
    end
end
