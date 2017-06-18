// Mourouzi Christos
// 7571
// Project: Imperative MPI Bitonic Sort


#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include "mpi.h"

struct timeval startwtime, endwtime;
double seq_time;


int N;          // data array size
int *a;         // one of the data arrays to be sorted as a whole
int *partner;         // another process' data array
int rank, workers;
int current_partner = -1;
double t1,t2;
MPI_Status status;


void init(void);
void print(void);
void test(void);
void test_final(void); 
inline void exchange(int i, int j);
inline void exchange_with_partner(int i, int j);
void impBitonicSort(void);


/** the main program **/ 
int main(int argc, char **argv) {

  if (argc != 2) {
    printf("Usage: %s q p\n  where n=2^q is each array size (power of two) and 2^p is number of processes\n", 
	   argv[0]);
    exit(1);
  }
  MPI_Init(&argc, &argv); 
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &workers);

  N = 1<<atoi(argv[1]); //N=2^argv[1]
  
  // Master process prints
  if (rank==0){
  printf("Number of procs=%d\n",workers);
  printf("Elements of Each Array=%d\n", N);
  printf("Elements to sort (ProcsxN)=%d\n\n", N*workers);}

  //Initialize array with N elements of each Process
  init();
  
  MPI_Barrier(MPI_COMM_WORLD); //wait everyone to continue
  t1 = MPI_Wtime();
  
  impBitonicSort(); // imperative bitonic sort in ascending
  
  MPI_Barrier(MPI_COMM_WORLD);//wait everyone to continue
  t2 = MPI_Wtime();
   
  //test if array of each process is sorted
  test();
  
  //test if all elements are sorted as a whole 
  if (rank==0) 
    test_final();
  MPI_Barrier(MPI_COMM_WORLD);
  
  //print last 16 elements (for practical view)
	if (rank==workers-1){
	printf("\n------->Final Array (Last 16 Elements)<-------\n");
	print();
	printf("Time for bitonic sort = %f\n\n", t2-t1);}
	
	MPI_Barrier(MPI_COMM_WORLD);	
  
  
  MPI_Finalize();//exit
}

/** -------------- SUB-PROCEDURES  ----------------- **/ 

/** procedure test() : verify sort results **/
void test() {
  int pass = 1;
  int i;
  for (i = 1; i < N; i++) {
    pass &= (a[i-1] <= a[i]);
  }
  
  if (pass==1)
	printf(" TEST of process %d Passed\n",rank+1);
  else
	printf(" TEST of process %d Failed\n",rank+1);
  
  if ( rank!=0 )
    MPI_Send(a, N, MPI_INT, 0, 1, MPI_COMM_WORLD);
}

/** procedure test_final() : verify sort results as whole **/
void test_final() {
  int i, partner_prev, flag = 1;
  for ( i = 1; i < workers; i++ ) {
    MPI_Recv(partner, N, MPI_INT, i, 1, MPI_COMM_WORLD, &status);
    if (i == 1) {
      if (a[N-1] > partner[0]) flag = 0; 
    }    
    else {
      if (partner_prev > partner[0]) flag = 0; 
    }
    partner_prev = partner[N-1];
  }
  printf(" Test all elements. Test: %s\n",(flag) ? "PASSED" : "FAILED");
}


/** procedure init() : initialize array "a" with data and print last 16 elements **/
void init() {
  a = (int *) malloc(N * sizeof(int));
  partner = (int *) malloc(N * sizeof(int));
  int i;
  for (i = 0; i < N; i++) {
    a[i] = rand() % N; // (N - i);
	}

if (rank==workers-1){
	printf("------->Initialize Array (Last 16 Elements)<-------\n");	
	print();}
}

/** procedure  print() : print last 16 array elements **/
void print() {
  int i;
  for (i = N-16; i < N; i++) {
		printf("%d\n", a[i]);
	}
  printf("\n");
  
  
}

/** INLINE procedure exchange() : pair swap of same matrix (local sort) **/
inline void exchange(int i, int j) {
  int t;
  t = a[i];
  a[i] = a[j];
  a[j] = t;
}

/** INLINE procedure exchange_with_partner() : pair swap with partner array **/
inline void exchange_with_partner(int i, int j) {
  int t;
  t = a[i];
  a[i] = partner[j];
  partner[j] = t;
}


/*
  imperative version of bitonic sort
*/
void impBitonicSort() {

  int i,j,k;
  int rank_i, rank_ij, offest_i, offest_ij;
  
  for (k=2; k<=N*workers; k=2*k) {
    for (j=k>>1; j>0; j=j>>1) {
      for (i=0; i<N*workers; i++) {
		int ij=i^j;    //XOR 
		if ((ij)>i) {    
          rank_i = (int) i/N;
          rank_ij = (int) ij / N;
          offest_i = i%N;   //where are we in the process' array
          offest_ij = ij%N; //where are we in the partner's process array
          if ( rank_i == rank || rank_ij == rank ){
            if (rank_i == rank && rank_ij == rank){//if same matrix
				if (((i&k)==0 && a[offest_i] > a[offest_ij]) || ((i&k)!=0 && a[offest_i] < a[offest_ij])) 
					exchange(offest_i,offest_ij); //exchange a[offest_i] = a[offest_ij];
				}
				
            if (rank_i == rank && rank_ij != rank){    //if partner is on different process
              if ( current_partner != rank_ij ){  //save time
                MPI_Send(a, N, MPI_INT, rank_ij, 1, MPI_COMM_WORLD);
                MPI_Recv(partner, N, MPI_INT, rank_ij, 1, MPI_COMM_WORLD, &status);
                current_partner = rank_ij;
              }
			  if (((i&k)==0 && a[offest_i] > partner[offest_ij]) || ((i&k)!=0 && a[offest_i] < partner[offest_ij])) 
					exchange_with_partner(offest_i, offest_ij); //exchange a[offest_i] = partner[offest_ij];
			  }
			  
            if (rank_i != rank && rank_ij == rank){    //if partner is on different process
              if ( current_partner != rank_i ){  //save time
                MPI_Recv(partner, N, MPI_INT, rank_i, 1, MPI_COMM_WORLD, &status);
                MPI_Send(a, N, MPI_INT, rank_i, 1, MPI_COMM_WORLD);
                current_partner = rank_i;
              }
			  if (((i&k)==0 && partner[offest_i] > a[offest_ij]) || ((i&k)!=0 && partner[offest_i] < a[offest_ij])) 
	        		exchange_with_partner(offest_ij, offest_i);//exchange partner[offest_ij] = a[offest_i];
			}
          }
		}
      }
    }
  }
}

