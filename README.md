#This repository is the MATLAB code for controlling the cascaded failures in interdependent networks.
my recovery process has two phases:


1) Avoiding further cascade
2) Recovery plan

1) Avoiding further cascade: For a case study of cascaded failures in the power network, we can model it using DC power flow model [1], to find the amount of power flow in each line.
Once the failure is detected in the system, we have to avoid further cascade (1) by load shedding or generating more power in each generator. This problem is a simple LP optimization (Section I-A) which can be solved using gurobi.
We can extend this model, by modeling the detection delay, and the delay for solving the optimization which will cause the cascade till it is detected.

The DC power model is just a linear model, where we only need the admittance of lines and the limits on the generator and load nodes.

I'll use the Italian 380kV Power Transmission Grid data set from "Vittorio Rosato":

The network contains N=310 nodes
#               
#       Nodes from 1  to 113 are sources (power is inserted),
#           nodes from 114 to 210 are loads (power is extracted)
#           nodes from 211 to 310 are junctions (power just flows by).
#           The network has 347 single lines and 14 double lines
#           (therefore 14 couples i-j are repeated).


2) Recovery plan: The recovery process, is more challenging. 
We can model it as mixed integer programming (Section I-B).

my recovery process has two phases:

https://www.dropbox.com/sh/kohhw8axrz5bwbo/AADxoyQ0mt3Vrbu8wtutOXf2a?dl=0

1) Avoiding further cascade
2) Recovery plan

1) Avoiding further cascade: For a case study of cascaded failures in the power network, we can model it using DC power flow model [1], to find the amount of power flow in each line.
Once the failure is detected in the system, we have to avoid further cascade (1) by load shedding or generating more power in each generator. This problem is a simple LP optimization (Section II-A) which can be solved using gurobi.
We can extend this model, by modeling the detection delay, and the delay for solving the optimization which will cause the cascade till it is detected.

The DC power model is just a linear model, where we only need the admittance of lines and the limits on the generator and load nodes.

We use the Italian 380kV Power Transmission Grid data set from "Vittorio Rosato":

The network contains N=310 nodes
#               
#       Nodes from 1  to 113 are sources (power is inserted),
#           nodes from 114 to 210 are loads (power is extracted)
#           nodes from 211 to 310 are junctions (power just flows by).
#           The network has 347 single lines and 14 double lines
#           (therefore 14 couples i-j are repeated).


2) Recovery plan: The recovery process, is more challenging. 
We can model it as mixed integer programming (Section II-B).

[1] Benjamin A Carreras, Vickie E Lynch, Ian Dobson, and David E Newman. Critical points and transitions in an electric power transmission model for cascading failure blackouts. Chaos: An interdisciplinary journal of nonlinear science, 2002.
