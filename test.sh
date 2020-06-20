#!/bin/sh
a=`kubectl exec -it mongo-0 -- bash -c "mongo --eval 'rs.status()'" | grep -i -c _id`
s=`kubectl get pods |grep -i "mongo*" | awk '{print $1}'|wc -l`
# continue until $n equals 5
while [ $a -le $s ]
do      
	
	v=( "mongo-$a.mongo:27017" )
	id=`kubectl exec -it mongo-0 -- bash -c "mongo --eval 'rs.add("$v")'" | grep -i -c _id`
        #kubectl get pods
	echo "Welcome $id times"
        
        a=$(( a+1 ))     # increments $n
done
