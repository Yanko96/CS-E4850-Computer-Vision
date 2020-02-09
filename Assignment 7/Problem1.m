%% First define the term frequency of our document database
term_freq=[0.05 0.20 0.02 0.10 0.60];

%% Next define the term frequency of the query and the documents
query_freq=[1/4 0 1/4 1/4 1/4];
d1_freq=[1/15 1/15 0 1/15 3/15];
d2_freq=[1/7 1/7 1/7 1/7 0];
d3_freq=[2/12 1/12 0 1/12 0];

%% Calculate The tf-idf weighted word occurrence value then 
weighted_word_occurence_query=query_freq.*log2(1./term_freq);
weighted_word_occurence_d1=d1_freq.*log2(1./term_freq);
weighted_word_occurence_d2=d2_freq.*log2(1./term_freq);
weighted_word_occurence_d3=d3_freq.*log2(1./term_freq);

%% Finally generate the plots
c = categorical({'cat','dog','mammals','mouse','pet'});
figure(1);
bar(c,weighted_word_occurence_query);
title('The tf-idf weighted word occurrence histogram for the Query')

figure(2);
bar(c,weighted_word_occurence_d1);
title('The tf-idf weighted word occurrence histogram for Document 1')

figure(3);
bar(c,weighted_word_occurence_d2);
title('The tf-idf weighted word occurrence histogram for Document 2')

figure(4);
bar(c,weighted_word_occurence_d3);
title('The tf-idf weighted word occurrence histogram for Document 3')

%% And the Similarity Measure 
sim_d1=1 - pdist([weighted_word_occurence_d1/norm(weighted_word_occurence_d1);weighted_word_occurence_query/norm(weighted_word_occurence_query)],'cosine')
sim_d2=1 - pdist([weighted_word_occurence_d2/norm(weighted_word_occurence_d2);weighted_word_occurence_query/norm(weighted_word_occurence_query)],'cosine')
sim_d3=1 - pdist([weighted_word_occurence_d3/norm(weighted_word_occurence_d3);weighted_word_occurence_query/norm(weighted_word_occurence_query)],'cosine')