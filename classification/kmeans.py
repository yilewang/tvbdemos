import time
import pandas as pd
from sklearn import metrics
from sklearn.cluster import KMeans
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt


n_clusters= 5
data = pd.read_excel("table_machine_learning.xlsx") #the excel filename
data.head()
features =list(data.columns) #import features in here
data=data[features]
start = time.time()
clustering_kmeans = KMeans(n_clusters=n_clusters,  n_init=300, random_state=0,precompute_distances='auto',n_jobs=-1)# the number of K is n_clusters.
data['clusters'] = clustering_kmeans.fit_predict(data)
tsne = TSNE(n_components=2, verbose=1, perplexity=30, n_iter=700, random_state=0)
tsne_results = tsne.fit_transform(data)
end = time.time()
print('{:.4f} s'.format(end - start))
tt = '{:.4f} s'.format(end - start)
df=pd.DataFrame(data)
df.to_csv('after.csv')
ts2done = tsne_results[:,0]
ts2dtwo = tsne_results[:,1]
id = pd.read_csv("Labels-1.csv")
id.head()
ids=[]
ids.extend(x[0]for x in id.values)
title='the number of clusters:', n_clusters
plt.figure(figsize=(10, 5))
scatter = plt.scatter(tsne_results[:, 0], tsne_results[:, 1], c=clustering_kmeans.labels_, cmap='rainbow')
plt.legend(*scatter.legend_elements(),
                    loc="upper left", title="Clusters")
plt.title(title)
for i in range(len(id.values)):
    plt.annotate(ids[i], xy = (ts2done[i], ts2dtwo[i]), xytext = (ts2done[i]+0.1, ts2dtwo[i]+0.1))
plt.show()
#ax = plt.figure(figsize=(15,8))
#plt.scatter(ts2done, ts2dtwo)
#plt.show()


index=metrics.silhouette_score(data, clustering_kmeans.labels_,  metric='euclidean')
print(index)
index_sample=metrics.silhouette_samples(data, clustering_kmeans.labels_,  metric='euclidean')
print(index_sample)
#pd.plotting.parallel_coordinates(data,'clusters')

