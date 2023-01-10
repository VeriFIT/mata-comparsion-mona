#include<stdio.h>
#include "BDD/bdd.h"
#include "DFA/dfa.h"
#include "Mem/mem.h"

/* removed GNUC_INLINE from bdd.c and bdd_internal.h --- ask PP */


DFA *NewDFA(unsigned n, bdd_manager *bddm)
{
  DFA *a;
  a = mem_alloc(sizeof *a);
  a->bddm = bddm;
  a->ns = n;
  a->q = mem_alloc((sizeof *(a->q)) * n);
  a->f = mem_alloc((sizeof *(a->f)) * n); 
  return a;
}



int main () {
	bdd_manager *bddm;
	bddm=bdd_new_manager(100,100);	
	bdd_ptr	a,b,c,d;
	a=bdd_find_leaf_hashed_add_root(bddm, 0);
	b=bdd_find_leaf_hashed_add_root(bddm, 1);
	c=bdd_find_leaf_hashed_add_root(bddm, 2);
	d=bdd_find_leaf_hashed_add_root(bddm, 3);

	bdd_ptr e,f;
	e=bdd_find_node_hashed_add_root(bddm,a,b,1);
	f=bdd_find_node_hashed_add_root(bddm,c,d,2);
	bdd_ptr h1,h2;

	h1=bdd_find_node_hashed_add_root(bddm, e, f, 0);
	h2=bdd_find_leaf_hashed_add_root(bddm,0);
	DFA *x;
	x=NewDFA(4,bddm);
	(x->f)[0]=-1; (x->f)[1]=1; (x->f)[2]=1; (x->f)[3]=-1;
	(x->q)[0]=h1; 
	(x->q)[1]=h1; 
	(x->q)[2]=h2; 
	(x->q)[3]=h2; 

	dfaPrintVerbose(x);	

	DFA *y,*z;
	y=dfaProject(x,0);
	dfaPrintVerbose(y);	
	z=dfaMinimize(y);

	printf("ALL OK\n");

	return 0;
}
