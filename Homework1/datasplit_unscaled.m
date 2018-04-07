
%rand("seed", 3);

data = csvread("data_unscaled.csv");

trainrows = (rand(rows(data), 1) <= (1/3));
testrows = ( (rand(rows(data), 1) <= .5) .* not(trainrows));
saverows = not(or(trainrows,testrows));

sum(trainrows)/rows(data)
sum(testrows)/rows(data)
sum(saverows)/rows(data)

traindata = data(nonzeros(trainrows),:);
valdata = data(nonzeros(testrows),:);
testdata = data(nonzeros(saverows),:);