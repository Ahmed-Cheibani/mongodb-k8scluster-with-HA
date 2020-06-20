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
>rs.status()
9. initiate replicaset
>rs.initiate()
10.store replicaset configurations into cfg variable
>var cfg = rs.conf()
11.add members to host
>cfg.members[0].host="mongo-0.mongo:27017"
12.refresh the configuration
>rs.reconfig(cfg)
13.add remaining pod as members of replicaset which acts as SECONDARY pods
>rs.add("mongo-1.mongo:27017")
>rs.add("mongo-2.mongo:27017")
14.check replicaset status. Now all pods are in replication to PRIMARY pod
rs.status()
If we scale the pods , we need to add scaled pods as members in replicaset.
To check members which are in replicasets
>mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo --eval 'rs.status()' | grep name
now increase pods to 4, to do that exit the pod like typing exit(leave from mongo client) again type exit(leave from pod). now you are on server
>kubectl scale sts mongo --replicas 4  
To add 4th pod into replication then switch to PRIMARY pod and add 4th pod as member
enter inside pod kubectl exec -it mongo-0 bash 
now you are inside pod
Switch to mongo client,type mongo
>rs.add("mongo-3.mongo:27017")
Note: Number pods to be scaled up/down = number pods should be added/removed as members in PRIMARY pod manually.
now check replicasets. exit the mongo client. and type 
>mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo --eval 'rs.status()' | grep name
you can see 
                        "name" : "mongo-0.mongo:27017",
                        "name" : "mongo-1.mongo:27017",
                        "name" : "mongo-2.mongo:27017",
                        "name" : "mongo-3.mongo:27017",
 15.now, Autoscale the pods based on cpu  utilization or you can create yaml file using horizontalpodscaler service(all yaml files are available in github repo. please check)
 >kubectl autoscale sts mongo --cpu-percent=50 --min=1 --max=10
 16. increase the load inside the pod
 by entering multiple times until load goes above given condition(better to give --cpu-percent below 10 to check pod scaling)
yes > /dev/null &
or you can also increase load below script while true; do printf .;done>>~/text(run inside the pod)
or if you want to monitor the cpu utilization without goes inside pod enter below command
kubectl exec -it  pod -- bash -c "while true; do printf .;done>>~/text
and now you check pods scaling 
kubectl get pods
or you want monitor scaling then
watch kubectl get pods
