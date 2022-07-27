## ST41 openmpi benchmark

1. init env variables. Your openFoam installation might be differen

```bash

source /opt/OpenFoam_v2206/etc/bashrc
```

2. Prepare repo data

```bash
git clone https://github.com/radiolok/fluidicpc
cd fluidicpc/bench/st41_50u/meshCase
./Allmesh # run mesh preparation
cd ../case/
```

3. Prepare data for openMPI - set slots=CPUnum in your system

```bash
vim hostfile

127.0.0.1 slots=16
```

4. Set number of threads for current run

```bash
vim system/decomposeParDict

numberOfSubdomains  16;// <= change value in this line

```

5. Run simulation fo 50 iterations:

```bash
./Allrun
```

6. 

```bash
Time = 50

smoothSolver:  Solving for Ux, Initial residual = 0.016608048, Final residual = 0.0014078031, No Iterations 1
smoothSolver:  Solving for Uy, Initial residual = 0.0078743367, Final residual = 0.00052424984, No Iterations 1
smoothSolver:  Solving for Uz, Initial residual = 0.062228509, Final residual = 0.0056502976, No Iterations 1
GAMG:  Solving for p, Initial residual = 0.074983923, Final residual = 0.00061506252, No Iterations 3
GAMG:  Solving for p, Initial residual = 0.001528043, Final residual = 9.3656366e-06, No Iterations 12
GAMG:  Solving for p, Initial residual = 0.00021100964, Final residual = 1.4637146e-06, No Iterations 7
GAMG:  Solving for p, Initial residual = 3.1508808e-05, Final residual = 2.0603363e-07, No Iterations 7
GAMG:  Solving for p, Initial residual = 7.9916881e-06, Final residual = 6.9259462e-08, No Iterations 4
GAMG:  Solving for p, Initial residual = 2.0248575e-06, Final residual = 1.8799949e-08, No Iterations 4
time step continuity errors : sum local = 0.00031827139, global = 4.4203807e-06, cumulative = -0.0019786412
smoothSolver:  Solving for omega, Initial residual = 0.0088505726, Final residual = 0.00054960281, No Iterations 3
smoothSolver:  Solving for k, Initial residual = 0.034761292, Final residual = 0.0020115187, No Iterations 3
ExecutionTime = 699.06 s  ClockTime = 699 s <<<=== 699s for current test

End

Finalising parallel run

```