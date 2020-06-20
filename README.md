1.Create a MongoDB setup 3 nodes on k8s.
2. Create Mongo replicasets:-adding primary and secondary configurations
3.Deploy a Mongo client and test the connectivity with mongo DB. 
4.Make sure that your Cluster is highly available and cost optimised i.e it should be able to scale/descale on below criteria:
- CPU
- Disk
To set up the MongoDB replica set, we need three things: A StorageClass, a Headless Service, and a StatefulSet
To create MongoDB pods its recommended to use Stateful sets instead of replicaset. Since pods are ephermal so DB pods should be connected to Prevoiusly attached pod. 
1.create storage class
>kubectl create -f sc.yaml
2.create persistentvolume
>kubectl create -f pv.yaml
3.create persistentvolumeclaim
>kubectl create -f pvc.yaml
4.create service
>kubectl create -f svc.yaml
5.create statefulsets with 3 replicas
>kubectl create -f sts.yaml
6.Enter inside to one of the pod which pod do you want to make primary pod
>kubectl exec -it mongo bash
7. after entering type mongo which makes you enter into mongo client where you execute mongo cmds
>mongo
8. check status of replicaset
rs0:rs.status()
9. initiate replicaset
rs0:rs.initiate()
10.store replicaset configurations into cfg variable
11.add members(pods) to conf’s
12.refresh replicaset
13.add remaining pod as members of replicaset which acts as SECONDARY pods
14.check replicaset status. Now all pods are in replication to PRIMARY pod
If we scale the pods , we need to add scaled pods as members in replicaset.
To check members which are in replicasets
>mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo --eval 'rs.status()' | grep name
now increase pods to 4
kubectl scale sts mongo --replicas 4
To add 4th pod into replication then switch to PRIMARY pod and add 4th pod as member
Switch to mongo client
rs.add("mongo-3.mongo:27017")
Note: Number pods to be scaled up/down = number pods should be added/removed as members in PRIMARY pod manually.
