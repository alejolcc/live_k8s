# Live_k8s
Demo project to play around Erlang distribution, k8s & broadway

The idea is to have one node that act as Server to be conected with a node from 
https://github.com/alejolcc/live_k8s_node

The conection is made via Erlang Distribution using the popular lib Libcluster (https://github.com/bitwalker/libcluster)

This server have a broadway to handle events that comes from the node via Phoenix PubSub, and write to the DB in batch to improve the performance
It have a live_view to see the conected nodes, and a broadway dashboard to see the load of the pipelines

# Running

Start the server & client using sname command 
```
iex --sname server -S mix phx.servr
```
Start the node 
```
iex --sname client -S mix
```
# Endpoints

To see the connected nodes you can visit

http://localhost:4000/nodes

To see the dashboard nodes you can visit

http://localhost:4000/dashboard
