

vocab=fileread('merged_vocab.txt');
vocab=strsplit(vocab);
load merged_docword.csv

x_fmt = merged_docword; % each row is different document. each column represents all possible words

[U_svd,S_svd,V_svd] = svds(x_fmt); % svd

n_dim = 2; % number of dimensions

x_princ = U_svd(:,1:n_dim)*S_svd(1:n_dim,1:n_dim); % get principal components

[k_clust, loc_clust] = kmeans(x_princ, 2); % kmeans clustering

% plot with document numbers
figure; hold on
for i=1:4930 % 4930 total documents
    if n_dim == 2
        if i<3431 % first 3430 are kos
            text(x_princ(i,1), x_princ(i,2), sprintf('%03d',i), 'Color', 'b');
        else % next 1500 are nips
            text(x_princ(i,1), x_princ(i,2), sprintf('%03d',i));
        end
    elseif n_dim == 3
        text(x_princ(i,1), x_princ(i,2), x_princ(i,3), sprintf('%03d',i));
    end
end
if n_dim == 2
    axis([ min(x_princ(:,1)), max(x_princ(:,1)), min(x_princ(:,2)), max(x_princ(:,2))])
elseif n_dim == 3
    axis([ min(x_princ(:,1)), max(x_princ(:,1)), min(x_princ(:,2)), max(x_princ(:,2)), min(x_princ(:,3)), max(x_princ(:,3)) ])
end
    
% plot with just dots
figure(2);

if n_dim == 2 
    scatter(x_princ(:,1), x_princ(:,2), 'filled');
elseif n_dim == 3
    scatter3(x_princ(:,1), x_princ(:,2), x_princ(:,3));
end

% adding cluster markings to scatter plot
hold on
if n_dim == 2 
    scatter(loc_clust(:,1), loc_clust(:,2), 250, 'kx');
elseif n_dim == 3
    scatter3(loc_clust(:,1), loc_clust(:,2), loc_clust(:,3), 250, 'kx');
end

%calculate accuracy of kmeans clustering when k=2
number_right = 0;
for i=1:4930 % 4930 total docs
    if i<3431 % first 3420 docs are kos
        if k_clust(i) == 1
           number_right = number_right + 1;
        end
    else % next 1500 are nips
        if k_clust(i) == 2
            number_right = number_right + 1;
        end
    end
end
accuracy = number_right / 4930;
disp(accuracy)


