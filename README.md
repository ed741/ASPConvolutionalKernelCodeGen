# Answer Set Programming implementation of cellular-processor-array multiply-free convolutional-filter code generation.

This implmentation defines the problem as a series of instruction that take an inital state to the desired final state, thus it is a forwards search of all possible instructions.

State is defined by atoms and registers. An atom is a defined by its origin (AX,AY) and a state specifies how many of which atoms exist in which registers. The function in/7 defines the storage, usage and transitions of the state as follows:
	in(AX,AY,C,R,X,Y,T) holds true iff:
	there are C atoms, originally from (AX, AY), in register R, at the processing element at (X,Y), at time step T.

The instructions add, move, and sub define the predicate in/7 for the respective times T for which they are defined based on the state at T-1.

## To run the code instruction Generator:

>$ gringo codeGen_in.lp codeGen_enc.lp | clasp 0


This will produce an output:
```
>clasp version 3.3.3
>Reading from stdin
>Solving...
>Answer: 1
>move(b,a,up,1) move(a,b,left,3) move(a,b,down,4) move(b,a,left,5) add(b,a,b,2) add(a,b,a,6) null(7)
>Optimization: -1
>Answer: 2
>move(a,a,down,1) move(b,a,left,2) move(a,b,up,5) add(b,a,b,3) add(a,b,a,6) null(4) null(7)
>Optimization: -2
>Answer: 3
>move(b,a,down,1) move(b,a,left,3) add(a,b,a,2) add(a,a,b,4) null(5) null(6) null(7)
>Optimization: -3
>OPTIMUM FOUND
>
>Models       : 3
>  Optimum    : yes
>Optimization : -3
>Calls        : 1
>Time         : 199.726s (Solving: 185.48s 1st Model: 4.10s Unsat: 122.36s)
>CPU Time     : 196.203s
```


This can be interperated as such:
* add(r1, r2, r3, t):
  * r1 := r2+r3. 
  * this instruction is done at time step t.
* move(r1, r2, dir, t):
  * r1 := r2_dir.
  * again, this instruction is done at time step t.
* sub(r1, r2, r3, t):
  * r1 := r2-r3. 
  * at time step t.
* null(t):
  * nothings happens at time step t, immediatly move on.

so for the 2x2 box filter example above we have to reorder the list of instructions as such:
Time Step T | Instruction          | Register **a**                | Register **b**
------------|----------------------|---------------------------|-----------------------
0 | intital state | [(0,0)] | []           
1 | move(**b**,**a**,down,1) | [(0,0)] | [(0,1)]
2 | add(**a**,**b**,**a**,2) | [(0,0),(0,1)] | [(0,1)]
3 | move(**b**,**a**,left,3) | [(0,0),(0,1)] | [(1,0),(1,1)]}
4 | add(**a**,**a**,**b**,4) | [(0,0),(0,1),(1,0),(1,1)] | [(1,0),(1,1)]}
5 | null(5) | [(0,0),(0,1),(1,0),(1,1)] | [(1,0),(1,1)]}
6 | null(6) | [(0,0),(0,1),(1,0),(1,1)] | [(1,0),(1,1)]}
7 | null(7) | [(0,0),(0,1),(1,0),(1,1)] | [(1,0),(1,1)]}

we see register **a** correctly holds the 2x2 box function, and this solution is optimal.
The solver is able to judge how optimal the instruction sequence is by how many of the 7 total instructions are null instructions, and maximise this number.
The problem is constrained to a maximum of 7 instructions because the memory and time required for longer instruction sequences makes this method intractable.

codeGen_in.lp defines the current filter, number of moves, and available registers.
goal_in(AX,AY,C,R) means the final state must contain C atoms orignally from (AX, AY) in register R.

codeGen_enc.lp defines the instructions behaviour and inforces that there must be an instruction at each time step, and the inital and final states be correct.

The solver then searches through all the options until if finds a valid set of moves that fulfils all the requirements that it can also prove is optimal.

